# SkillTrek
A decentralized application for tracking and sharing progress in learning new skills or hobbies.

## Features
- Create skill tracking profiles
- Add and update skills/hobbies
- Track progress milestones
- Share and verify achievements
- View other users' progress

## Setup and Installation
1. Clone the repository
2. Install Clarinet (if not already installed)
3. Run `clarinet check` to verify the contract
4. Run `clarinet test` to run the test suite

## Usage Examples
```clarity
;; Create a skill profile
(contract-call? .skill-trek create-profile "John Doe" "Artist")

;; Add a new skill
(contract-call? .skill-trek add-skill "Oil Painting" u1)

;; Update skill progress
(contract-call? .skill-trek update-progress "Oil Painting" u60)

;; Add achievement milestone
(contract-call? .skill-trek add-milestone "Oil Painting" "First Exhibition" "Hosted first art exhibition")
```

## Dependencies
- Clarity language
- Clarinet for testing and deployment
