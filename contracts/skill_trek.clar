;; Constants and Errors
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-invalid-data (err u102))
(define-constant err-already-exists (err u103))
(define-constant err-invalid-range (err u104))

;; Data Types
(define-map profiles
  principal
  {
    name: (string-ascii 64),
    bio: (string-ascii 256),
    created-at: uint
  }
)

(define-map skills
  { owner: principal, skill-name: (string-ascii 64) }
  {
    level: uint,
    progress: uint,
    last-updated: uint
  }
)

(define-map milestones
  { owner: principal, skill-name: (string-ascii 64), title: (string-ascii 64) }
  {
    description: (string-ascii 256),
    achieved-at: uint,
    verified: bool
  }
)

;; Private Functions
(define-private (validate-progress (progress uint))
  (if (> progress u100)
    err-invalid-range
    (ok true))
)

(define-private (validate-level (level uint))
  (if (or (< level u1) (> level u100))
    err-invalid-range
    (ok true))
)

;; Public Functions
(define-public (create-profile (name (string-ascii 64)) (bio (string-ascii 256)))
  (let ((existing-profile (map-get? profiles tx-sender)))
    (if (is-some existing-profile)
      err-already-exists
      (ok (map-set profiles tx-sender {
        name: name,
        bio: bio,
        created-at: block-height
      })))
  )
)

(define-public (add-skill (skill-name (string-ascii 64)) (initial-level uint))
  (let ((existing-skill (map-get? skills { owner: tx-sender, skill-name: skill-name })))
    (match (validate-level initial-level)
      success (if (is-some existing-skill)
        err-already-exists
        (ok (map-set skills 
          { owner: tx-sender, skill-name: skill-name }
          {
            level: initial-level,
            progress: u0,
            last-updated: block-height
          }
        )))
      error error)
  )
)

(define-public (update-progress (skill-name (string-ascii 64)) (new-progress uint))
  (let ((skill-data (get-skill-data tx-sender skill-name)))
    (match (validate-progress new-progress)
      success (match skill-data
        skill-map (ok (map-set skills
          { owner: tx-sender, skill-name: skill-name }
          {
            level: (get level skill-map),
            progress: new-progress,
            last-updated: block-height
          }
        ))
        err-not-found)
      error error)
  )
)

[... rest of the contract remains the same ...]
