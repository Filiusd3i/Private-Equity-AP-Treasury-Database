-- 1099 Eligible Vendor Report with Payment Totals
-- Identifies vendors requiring 1099 forms based on payment thresholds
SELECT 
    v.vendor_name, 
    v.vendor_id,
    v.is_1099_eligible, 
    v.[W-9] AS Has_W9_On_File, 
    v.[Date W-9 submitted] AS W9_Submission_Date,
    Sum(p.amount_paid) AS Total_Payments,
    Count(DISTINCT i.invoice_id) AS Invoice_Count
FROM 
    [vendor list] v
LEFT JOIN 
    Invoices i ON v.vendor_id = i.vendor_id
LEFT JOIN 
    payments p ON i.invoice_id = p.invoice_id
WHERE 
    Year(p.payment_date) = Year(Date())
    AND v.is_1099_eligible = True
GROUP BY 
    v.vendor_name, v.vendor_id, v.is_1099_eligible, v.[W-9], v.[Date W-9 submitted]
HAVING 
    Sum(p.amount_paid) > 600
ORDER BY 
    Sum(p.amount_paid) DESC;

-- Fund Expense Allocation Detail
-- Shows how expenses are distributed across funds
SELECT 
    f.fund_id,
    f.fund_name, 
    f.entity,
    ia.allocation_percentage AS Allocation_Pct,
    i.invoice_number,
    i.invoice_date,
    i.total_amount AS Invoice_Total,
    FORMAT(i.total_amount * ia.allocation_percentage / 100, "Currency") AS Allocated_Amount,
    v.vendor_name,
    i.Approval_status
FROM 
    Funds f
INNER JOIN 
    [Invoice allocation] ia ON f.fund_id = ia.fund_id
INNER JOIN 
    Invoices i ON ia.invoice_id = i.invoice_id
INNER JOIN 
    [vendor list] v ON i.vendor_id = v.vendor_id
WHERE 
    i.invoice_date BETWEEN #1/1/2023# AND #12/31/2023#
ORDER BY 
    f.fund_name, i.invoice_date;

-- Unpaid Invoice Report with Aging
-- Identifies overdue invoices with aging categories
SELECT 
    i.invoice_id,
    i.invoice_number,
    v.vendor_name,
    i.invoice_date,
    i.due_date,
    i.total_amount,
    IIF(IsNull(Sum(p.amount_paid)), 0, Sum(p.amount_paid)) AS Amount_Paid,
    i.total_amount - IIF(IsNull(Sum(p.amount_paid)), 0, Sum(p.amount_paid)) AS Balance_Due,
    DateDiff("d", i.due_date, Date()) AS Days_Overdue,
    SWITCH(
        DateDiff("d", i.due_date, Date()) <= 0, "Current",
        DateDiff("d", i.due_date, Date()) <= 30, "1-30 Days",
        DateDiff("d", i.due_date, Date()) <= 60, "31-60 Days",
        DateDiff("d", i.due_date, Date()) <= 90, "61-90 Days",
        DateDiff("d", i.due_date, Date()) > 90, "Over 90 Days"
    ) AS Aging_Category,
    f.fund_name
FROM 
    Invoices i
INNER JOIN 
    [vendor list] v ON i.vendor_id = v.vendor_id
INNER JOIN 
    Funds f ON i.fund_id = f.fund_id
LEFT JOIN 
    payments p ON i.invoice_id = p.invoice_id
GROUP BY 
    i.invoice_id, i.invoice_number, v.vendor_name, i.invoice_date, 
    i.due_date, i.total_amount, f.fund_name
HAVING 
    (i.total_amount - IIF(IsNull(Sum(p.amount_paid)), 0, Sum(p.amount_paid))) > 0
ORDER BY 
    Days_Overdue DESC;

-- Deal-to-Fund Allocation Report
-- Shows how deals are structured across multiple funds
SELECT 
    da.deal_name,
    f.fund_name,
    f.entity,
    da.allocation_percentage,
    e.first_name & " " & e.last_name AS Approver_Name,
    e.Email_address AS Approver_Email
FROM 
    [Deal Allocations] da
INNER JOIN 
    Funds f ON da.fund_id = f.fund_id
INNER JOIN 
    Employees e ON da.approver_id = e.ID
ORDER BY 
    da.deal_name, da.allocation_percentage DESC;

-- Vendor Expense by Fund Analysis
-- Analyzes vendor expenses distribution across funds
SELECT 
    v.vendor_name,
    f.fund_name,
    COUNT(i.invoice_id) AS Invoice_Count,
    SUM(i.total_amount) AS Total_Spent,
    MIN(i.invoice_date) AS First_Invoice,
    MAX(i.invoice_date) AS Latest_Invoice,
    AVG(i.total_amount) AS Average_Invoice_Amount
FROM 
    [vendor list] v
INNER JOIN 
    Invoices i ON v.vendor_id = i.vendor_id
INNER JOIN 
    Funds f ON i.fund_id = f.fund_id
WHERE 
    i.invoice_date BETWEEN #1/1/2023# AND #12/31/2023#
GROUP BY 
    v.vendor_name, f.fund_name
ORDER BY 
    SUM(i.total_amount) DESC; 