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