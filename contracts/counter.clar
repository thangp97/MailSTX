;; Simple Message Board Contract
;; This contract allows users to post and read messages

;; 
(define-map sender-messages
  {sender: principal, id: uint}
  (string-utf8 280))

;; 
(define-map recipient-messages
  {recipient: principal, id: uint}
  (string-utf8 280))

;; 
(define-map sender-count
  principal
  uint)

;; 
(define-map recipient-count
  principal
  uint)

(define-map senders-list uint principal)

(define-constant contract-owner 'ST3B3S42JW940ZNV3AQB92TF70YD8K6NQKFEGR5PN)

(define-data-var total-fees uint u0)
(define-data-var sender-index uint u0)
(define-data-var prize-pool-owner principal contract-owner)

;; Public function to add a new message
(define-public (send-message
  (content (string-utf8 280))
  (recipient principal))

  (let (
        (sender-id (default-to u0 (map-get? sender-count tx-sender)))
        (recipient-id (default-to u0 (map-get? recipient-count recipient)))
        (index (var-get sender-index))
        (current-fees (var-get total-fees))
    )
    (match (stx-transfer? u500 tx-sender 'ST3B3S42JW940ZNV3AQB92TF70YD8K6NQKFEGR5PN.mailstx) 
      ok-result 
      (begin
        ;; 
        (map-set sender-messages
          {sender: tx-sender, id: sender-id}
          content)
        ;; 
        (map-set recipient-messages
          {recipient: recipient, id: recipient-id}
          content)
        ;; 
        (map-set sender-count tx-sender (+ sender-id u1))
        (map-set recipient-count recipient (+ recipient-id u1))

        ;; Count Sender
        (map-set senders-list index tx-sender)
        (var-set sender-index (+ index u1))

        ;; Add fees
        (var-set total-fees (+ current-fees u500))

        
        
        (ok sender-id)
      ) 
      
      err-result 
        (err u400)
    )
  )
)


(define-read-only (get-sent-message (user principal) (id uint))
  (map-get? sender-messages {sender: user, id: id}))

(define-read-only (get-received-message (user principal) (id uint))
  (map-get? recipient-messages {recipient: user, id: id}))

(define-read-only (get-sent-count (user principal))
  (default-to u0 (map-get? sender-count user)))

(define-read-only (get-received-count (user principal))
  (default-to u0 (map-get? recipient-count user)))

(define-read-only (get-prize-pool-balance)
  (ok (stx-get-balance 'ST3B3S42JW940ZNV3AQB92TF70YD8K6NQKFEGR5PN.mailstx)))