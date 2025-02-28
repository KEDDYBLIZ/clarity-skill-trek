import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Test profile creation and retrieval",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    
    let block = chain.mineBlock([
      Tx.contractCall('skill-trek', 'create-profile', 
        [types.ascii("John Doe"), types.ascii("Learning artist")],
        deployer.address
      )
    ]);
    
    block.receipts[0].result.expectOk();
    
    let response = chain.callReadOnlyFn(
      'skill-trek',
      'get-profile',
      [types.principal(deployer.address)],
      deployer.address
    );
    
    response.result.expectOk();
  }
});

Clarinet.test({
  name: "Test skill addition and progress tracking",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    
    // Add skill
    let block = chain.mineBlock([
      Tx.contractCall('skill-trek', 'add-skill',
        [types.ascii("Oil Painting"), types.uint(1)],
        deployer.address
      )
    ]);
    
    block.receipts[0].result.expectOk();
    
    // Update progress
    block = chain.mineBlock([
      Tx.contractCall('skill-trek', 'update-progress',
        [types.ascii("Oil Painting"), types.uint(60)],
        deployer.address
      )
    ]);
    
    block.receipts[0].result.expectOk();
    
    // Verify skill data
    let response = chain.callReadOnlyFn(
      'skill-trek',
      'get-skill-data',
      [types.principal(deployer.address), types.ascii("Oil Painting")],
      deployer.address
    );
    
    response.result.expectOk();
  }
});

Clarinet.test({
  name: "Test milestone creation and verification",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    
    let block = chain.mineBlock([
      Tx.contractCall('skill-trek', 'add-milestone',
        [
          types.ascii("Oil Painting"),
          types.ascii("First Exhibition"),
          types.ascii("Hosted first art exhibition")
        ],
        deployer.address
      )
    ]);
    
    block.receipts[0].result.expectOk();
    
    let response = chain.callReadOnlyFn(
      'skill-trek',
      'get-milestone',
      [
        types.principal(deployer.address),
        types.ascii("Oil Painting"),
        types.ascii("First Exhibition")
      ],
      deployer.address
    );
    
    response.result.expectOk();
  }
});
