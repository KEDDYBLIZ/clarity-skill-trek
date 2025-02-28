;; Constants and Errors
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-invalid-data (err u102))

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

;; Public Functions
(define-public (create-profile (name (string-ascii 64)) (bio (string-ascii 256)))
  (ok (map-set profiles tx-sender {
    name: name,
    bio: bio,
    created-at: block-height
  }))
)

(define-public (add-skill (skill-name (string-ascii 64)) (initial-level uint))
  (ok (map-set skills 
    { owner: tx-sender, skill-name: skill-name }
    {
      level: initial-level,
      progress: u0,
      last-updated: block-height
    }
  ))
)

(define-public (update-progress (skill-name (string-ascii 64)) (new-progress uint))
  (let ((skill-data (get-skill-data tx-sender skill-name)))
    (match skill-data
      skill-map (ok (map-set skills
        { owner: tx-sender, skill-name: skill-name }
        {
          level: (get level skill-map),
          progress: new-progress,
          last-updated: block-height
        }
      ))
      err-not-found
    )
  )
)

(define-public (add-milestone (skill-name (string-ascii 64)) (title (string-ascii 64)) (description (string-ascii 256)))
  (ok (map-set milestones
    { owner: tx-sender, skill-name: skill-name, title: title }
    {
      description: description,
      achieved-at: block-height,
      verified: false
    }
  ))
)

;; Read Only Functions
(define-read-only (get-profile (user principal))
  (ok (map-get? profiles user))
)

(define-read-only (get-skill-data (user principal) (skill-name (string-ascii 64)))
  (ok (map-get? skills { owner: user, skill-name: skill-name }))
)

(define-read-only (get-milestone (user principal) (skill-name (string-ascii 64)) (title (string-ascii 64)))
  (ok (map-get? milestones { owner: user, skill-name: skill-name, title: title }))
)
