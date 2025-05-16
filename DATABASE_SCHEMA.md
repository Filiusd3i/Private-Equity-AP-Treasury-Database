# Database Schema Details

This document provides the detailed schema for each table in the Microsoft Access database.

## Table Definitions

### TABLE: Deal Allocations
-----------------------------
Field: allocation_id | Type: 3 (Integer) | Size: 2
Field: deal_name | Type: 10 (Text) | Size: 255
Field: fund_id | Type: 3 (Integer) | Size: 2
Field: allocation_percentage | Type: 7 (Float/Double) | Size: 8
Field: approver_id | Type: 7 (Float/Double) | Size: 8  *(Note: Consider if approver_id should be Integer/Long Integer linking to Employees.ID)*
Indexes:
  allocation_id (Unique: True) - Primary Key
  approver_id (Unique: False)
  deal_name (Unique: False)
  fund_id (Unique: False)
  FundsDeal Allocations (Unique: False) - Likely a relationship name

### TABLE: Employees
-----------------------------
Field: ID | Type: 4 (Long Integer) | Size: 4
Field: first_name | Type: 10 (Text) | Size: 255
Field: last_name | Type: 10 (Text) | Size: 255
Field: Role | Type: 10 (Text) | Size: 255
Field: is_active | Type: 1 (Yes/No) | Size: 1
Field: Location | Type: 10 (Text) | Size: 255
Field: Email_address | Type: 10 (Text) | Size: 255
Field: Phone_number | Type: 10 (Text) | Size: 255
Field: Company | Type: 10 (Text) | Size: 255
Indexes:
  ID (Unique: True) - Primary Key

### TABLE: Funds
-----------------------------
Field: fund_id | Type: 3 (Integer) | Size: 2
Field: fund_name | Type: 10 (Text) | Size: 255
Field: entity | Type: 10 (Text) | Size: 255
Field: description | Type: 12 (Memo/Long Text) | Size: 0
Field: is Active | Type: 10 (Text) | Size: 255 *(Note: Consider Yes/No type if boolean)*
Indexes:
  fund_id (Unique: True) - Primary Key

### TABLE: Invoice allocation
-----------------------------
Field: invoice_id | Type: 4 (Long Integer) | Size: 4
Field: fund_id | Type: 4 (Long Integer) | Size: 4
Field: allocation_percentage | Type: 4 (Long Integer) | Size: 4 *(Note: Percentage is often Float/Double. If storing as 50 for 50%, then Long Integer is fine, otherwise adjust type)*
Indexes:
  fund_id (Unique: False)
  InvoicesInvoice allocation (Unique: True) - Composite Key part 1
  PrimaryKey (Unique: True) - This typically refers to a composite key (invoice_id, fund_id)

### TABLE: Invoices
-----------------------------
Field: invoice_id | Type: 4 (Long Integer) | Size: 4
Field: vendor_id | Type: 4 (Long Integer) | Size: 4
Field: fund_id | Type: 3 (Integer) | Size: 2 *(Note: This might be a default fund_id if invoice can be allocated to multiple funds via `Invoice allocation` table)*
Field: invoice_number | Type: 10 (Text) | Size: 255
Field: invoice_date | Type: 8 (Date/Time) | Size: 8
Field: due_date | Type: 8 (Date/Time) | Size: 8
Field: total_amount | Type: 10 (Text) | Size: 255 *(Note: Monetary amounts should ideally be Currency type in Access, or Double for calculations. Text is not ideal.)*
Field: Notes/Description | Type: 12 (Memo/Long Text) | Size: 0
Field: Approval_status | Type: 10 (Text) | Size: 255
Field: is_custom_allocated | Type: 10 (Text) | Size: 255 *(Note: Consider Yes/No type if boolean)*
Indexes:
  fund_id (Unique: False)
  FundsInvoices (Unique: False) - Likely a relationship name
  PrimaryKey (Unique: True) - Refers to invoice_id
  vendor_id (Unique: False)

### TABLE: Paste Errors
-----------------------------
Field: F1 | Type: 10 (Text) | Size: 255 *(Utility table, likely for temporary import error logging)*

### TABLE: payments
-----------------------------
Field: payment_id | Type: 4 (Long Integer) | Size: 4
Field: invoice_id | Type: 4 (Long Integer) | Size: 4
Field: payment_date | Type: 8 (Date/Time) | Size: 8
Field: amount_paid | Type: 5 (Double) | Size: 8 *(Appropriate for currency)*
Field: notes | Type: 10 (Text) | Size: 255
Indexes:
  amount_paid (Unique: False)
  Index_F3A895D2_0D7C_4F5A (Unique: True) - Refers to payment_id (likely Primary Key)
  Invoicespayments (Unique: False) - Likely a relationship name

### TABLE: temp_import_vendors
-----------------------------
Field: temp_vendor_id | Type: 4 (Long Integer) | Size: 4
Field: vendor_name | Type: 10 (Text) | Size: 255
Field: contact_name | Type: 10 (Text) | Size: 255
Field: phone_number | Type: 10 (Text) | Size: 50
Field: email | Type: 10 (Text) | Size: 255
Field: address | Type: 10 (Text) | Size: 255
Indexes:
  Index_51BE59D2_82C0_4AE1 (Unique: True) - Refers to temp_vendor_id (likely Primary Key)

### TABLE: Vendor allocation
-----------------------------
Field: vendor_id | Type: 4 (Long Integer) | Size: 4
Field: vendor_name | Type: 10 (Text) | Size: 255 *(Note: Redundant if vendor_id links to `vendor list`. Normalization would remove this.)*
Field: fund_id | Type: 3 (Integer) | Size: 2
Field: Allocation_Percentage | Type: 4 (Long Integer) | Size: 4 *(Note: Same as Invoice Allocation percentage type consideration)*
Field: Description | Type: 10 (Text) | Size: 255
Indexes:
  fund_id (Unique: False)
  FundsVendor allocation (Unique: False) - Likely a relationship name
  vendor listVendor allocation (Unique: False) - Likely a relationship name
  Vendor_id (Unique: False)

### TABLE: vendor list
-----------------------------
Field: vendor_id | Type: 4 (Long Integer) | Size: 4
Field: vendor_name | Type: 10 (Text) | Size: 255
Field: vendor_type | Type: 10 (Text) | Size: 255
Field: contact_info | Type: 10 (Text) | Size: 255
Field: address | Type: 10 (Text) | Size: 255
Field: description | Type: 12 (Memo/Long Text) | Size: 0
Field: approver_id | Type: 4 (Long Integer) | Size: 4 *(Links to Employees.ID)*
Field: payment_term | Type: 10 (Text) | Size: 255
Field: is_1099_eligible | Type: 1 (Yes/No) | Size: 1
Field: is_active | Type: 1 (Yes/No) | Size: 1
Field: W-9 | Type: 4 (Long Integer) | Size: 4 *(Note: This seems to imply a link or status. If it's a boolean "Has W-9", Yes/No is better. If it's an ID to a W9 document table, Long Integer is fine.)*
Field: Date W-9 submitted | Type: 8 (Date/Time) | Size: 8
Indexes:
  Employeesvendor list (Unique: False) - Likely a relationship name
  vendor_id (Unique: True) - Primary Key

## Notes on Data Types and Indexes:
- **Type Codes**: Correspond to Microsoft Access / DAO data types. Textual descriptions (e.g., Integer, Text) are provided for clarity.
- **Size**: For Text fields, it's the maximum character length. For numeric types, it relates to the specific numeric type (e.g., Integer, Long Integer, Double). For Date/Time and Yes/No, it's fixed. Memo/Long Text has a variable size (0 in schema means not predefined limit other than Access's max).
- **Primary Keys**: Generally indicated by `(Unique: True)` on the main ID field or a specified `PrimaryKey` index.
- **Relationships**: Index names like `FundsDeal Allocations` or `Invoicespayments` often denote relationships enforced in Access. Foreign keys are typically indexed for performance but may not always be marked unique.
- **Suggestions**: Some fields have notes with suggestions for type changes (e.g., Text to Currency for monetary values, Text to Yes/No for booleans) for better data integrity and functionality within Access. These reflect best practices. 