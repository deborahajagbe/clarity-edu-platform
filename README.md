# Clarity EduChain - Educational Resource Sharing and Reimbursement Platform

## Overview

**Clarity EduChain** is a decentralized platform designed to facilitate the sharing, acquisition, and reimbursement of educational resources. By leveraging the security and transparency of the Stacks blockchain, this smart contract ensures equitable access, sustainable management, and flexibility for all participants.

---

## Features

### Core Functionalities:
- **Resource Management**: 
  - Share and acquire educational resources transparently.
  - Limit resource allocation per user and enforce maximum limits.

- **Financial Transactions**:
  - Handle STX payments for resource acquisition and platform fees.
  - Request reimbursements for unused resources.

- **Governance**:
  - Adjust key platform parameters such as resource price, platform fees, and reimbursement rates.
  - Enforce admin-only privileges for sensitive operations.

### Key Highlights:
- Transparent tracking of user balances (resources and STX).
- Automatic enforcement of constraints (e.g., price validation, balance checks).
- Configurable platform fees and reimbursement rates for sustainability.

---

## Smart Contract Structure

### 1. **Constants**
Defines key error codes and system-level parameters for governance and error handling:
- `contract-admin`: Specifies the admin account.
- Error constants: For common issues like invalid prices, insufficient balances, or unauthorized access.

### 2. **Data Variables**
Manages platform configurations and system metrics:
- **Resource Pricing**:
  - `resource-price`: Unit price of a resource.
  - `platform-fee-rate`: Platform fee as a percentage.
  - `reimbursement-rate`: Percentage of reimbursement for unused resources.

- **Limits**:
  - `max-resource-per-user`: Maximum resources allowed per user.
  - `total-resource-limit`: Overall platform resource cap.

- **Metrics**:
  - `current-resource-balance`: Tracks the total allocated resources.

### 3. **Data Maps**
Tracks user-specific data:
- **User Resource Balances**: Maps users to their resource holdings.
- **User STX Balances**: Maps users to their STX balances.
- **Listed Resources**: Tracks resources listed for sharing by users, including quantity and price.

### 4. **Private Functions**
Handles internal logic for computations:
- **Fee Calculation**: Compute platform fees based on transactions.
- **Reimbursement Calculation**: Compute refunds for unused resources.
- **Resource Balance Adjustment**: Ensures platform-wide resource limits are respected.

### 5. **Public Functions**
Enables platform operations:
- **Admin Actions**:
  - Adjust platform parameters (`resource-price`, `platform-fee-rate`, etc.).
  - Modify system-wide resource limits.

- **User Actions**:
  - Share resources (`list-resources`).
  - Remove listed resources (`remove-resources`).
  - Acquire resources from other users (`acquire-resources`).
  - Request reimbursement for unused resources (`request-reimbursement`).

---

## Example Workflows

### 1. **Listing a Resource**
A user lists a resource for sharing:
```clarity
(define-public (list-resources (quantity uint) (price uint)))
```
- Checks if the user has sufficient resources.
- Updates the user's listing in the `resources-listed` map.

### 2. **Acquiring a Resource**
A user acquires a resource from another user:
```clarity
(define-public (acquire-resources (provider principal) (quantity uint)))
```
- Deducts STX from the buyer and transfers it to the seller.
- Adjusts the resource and STX balances for both parties.
- Ensures platform fees are distributed to the admin.

### 3. **Requesting Reimbursement**
A user requests a refund for unused resources:
```clarity
(define-public (request-reimbursement (quantity uint)))
```
- Validates the user's resource balance and the contract's STX balance.
- Adjusts both balances and processes the reimbursement.

---

## Installation and Deployment

### Prerequisites:
- [Stacks CLI](https://github.com/blockstack/stacks-cli)
- A funded Stacks wallet for deployment.

### Steps:
1. Clone the repository and navigate to the project directory:
   ```bash
   git clone https://github.com/your-repo/clarity-edu-platform.git
   cd clarity-edu-platform
   ```
2. Deploy the smart contract:
   ```bash
   clarity-cli deploy clarity-edu-platform.clar
   ```

---

## Security and Best Practices

- **Admin Privileges**: Critical functions are restricted to the `contract-admin`.
- **Validation**: All inputs (e.g., prices, quantities) are validated to prevent misuse.
- **Resource Limits**: Ensures no single user or transaction can overwhelm the system.

---

## Contributing

We welcome contributions! Follow these steps:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit and push changes, then create a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgements

Clarity EduChain is inspired by the vision of decentralized education, fostering accessibility and fairness through blockchain technology.
