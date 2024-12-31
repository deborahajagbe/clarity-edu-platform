;; Project: clarity-edu-platform
;; Clarity EduChain - Educational Resource Sharing and Reimbursement Platform
;;
;; This smart contract facilitates a decentralized platform for sharing and acquiring educational resources.
;; Key functionalities include:
;; - Setting and adjusting platform parameters such as resource price, platform fees, and reimbursement rates.
;; - Listing resources for sharing, acquiring resources from others, and processing reimbursements for unused resources.
;; - Enforcing constraints on resource allocation, pricing, and platform governance.
;; - Tracking user balances in resources and STX, ensuring transactions are transparent and secure.
;;
;; Designed to promote accessibility and efficient management of educational resources, 
;; this contract ensures fairness, sustainability, and flexibility for all participants.

;;  ---------------
;; Define Constants
;; ----------------------------------

;; System constants for managing errors and permissions
(define-constant contract-admin tx-sender) ;; Administrator of the contract
(define-constant err-admin-only (err u200)) ;; Error: Admin-only access required
(define-constant err-insufficient-balance (err u201)) ;; Error: Insufficient balance
(define-constant err-transfer-issue (err u202)) ;; Error: Transfer failed
(define-constant err-price-invalid (err u203)) ;; Error: Invalid price
(define-constant err-quantity-invalid (err u204)) ;; Error: Invalid quantity
(define-constant err-fee-invalid (err u205)) ;; Error: Invalid fee
(define-constant err-refund-issue (err u206)) ;; Error: Refund failed
(define-constant err-same-user-transaction (err u207)) ;; Error: Transaction between same user
(define-constant err-exceeds-reserve-limit (err u208)) ;; Error: Reserve limit exceeded
(define-constant err-invalid-reserve (err u209)) ;; Error: Invalid reserve limit

;; ----------------------------------
;; Define Data Variables
;; ----------------------------------

;; Contract-level configurations and system metrics
(define-data-var resource-price uint u50) ;; Unit price of a resource
(define-data-var max-resource-per-user uint u500) ;; Maximum resources per user
(define-data-var platform-fee-rate uint u10) ;; Platform fee as a percentage
(define-data-var reimbursement-rate uint u80) ;; Reimbursement rate percentage
(define-data-var total-resource-limit uint u10000) ;; System-wide resource limit
(define-data-var current-resource-balance uint u0) ;; Current total resource allocation

;; ----------------------------------
;; Define Data Maps
;; ----------------------------------

;; User-specific data mappings
(define-map user-resource-balance principal uint) ;; User's resource balance
(define-map user-stx-balance principal uint) ;; User's STX balance
(define-map resources-listed {user: principal} {quantity: uint, price: uint}) ;; Listed resources by users

;; ----------------------------------
;; Private Functions
;; ----------------------------------

;; Compute the platform fee for a given amount
(define-private (compute-platform-fee (amount uint))
  (/ (* amount (var-get platform-fee-rate)) u100))

;; Compute the reimbursement for a given quantity of resources
(define-private (compute-reimbursement (amount uint))
  (/ (* amount (var-get resource-price) (var-get reimbursement-rate)) u100))

;; Adjust the system's resource balance, ensuring it does not exceed the limit
(define-private (adjust-resource-balance (amount int))
  (let (
    (current-balance (var-get current-resource-balance))
    (new-balance (if (< amount 0)
                     (if (>= current-balance (to-uint (- 0 amount)))
                         (- current-balance (to-uint (- 0 amount)))
                         u0)
                     (+ current-balance (to-uint amount)))))
    (asserts! (<= new-balance (var-get total-resource-limit)) err-exceeds-reserve-limit)
    (var-set current-resource-balance new-balance)
    (ok true)))

;; ----------------------------------
;; Public Functions
;; ----------------------------------

;; Administrative Functions
;; Set resource price (requires admin privileges)
(define-public (set-resource-price (new-price uint))
  (begin
    (asserts! (is-eq tx-sender contract-admin) err-admin-only)
    (asserts! (> new-price u0) err-price-invalid)
    (var-set resource-price new-price)
    (ok true)))

