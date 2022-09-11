USE H_Accounting;
DROP PROCEDURE IF EXISTS `syosinov_sp`;

-- The tpycal delimiter for Stored procedures is a double dollar sign
DELIMITER $$

	CREATE PROCEDURE `syosinov_sp`(varCalendarYear SMALLINT)
	BEGIN
  
	-- Define variables inside procedure
    DECLARE varRevenue 			DOUBLE DEFAULT 0;
    DECLARE varRevenuePrevious			DOUBLE DEFAULT 0;
    DECLARE varReturnsRefundsDiscounts 			DOUBLE DEFAULT 0;
    DECLARE varReturnsRefundsDiscountsPrevious 		 DOUBLE DEFAULT 0;
    DECLARE varCOGS 			DOUBLE DEFAULT 0;
    DECLARE varCOGSPrevious 			DOUBLE DEFAULT 0;
    DECLARE varGrossProfit 		DOUBLE DEFAULT 0;
    DECLARE varGrossProfitPrevious 		DOUBLE DEFAULT 0;
	DECLARE varAdminExp 		DOUBLE DEFAULT 0;
    DECLARE varAdminExpPrevious 		DOUBLE DEFAULT 0;
    DECLARE varSellingExp		DOUBLE DEFAULT 0;
    DECLARE varSellingExpPrevious		DOUBLE DEFAULT 0;
    DECLARE varOtherExp			DOUBLE DEFAULT 0;
    DECLARE varOtherExpPrevious			DOUBLE DEFAULT 0;
    DECLARE varOtherIncome		DOUBLE DEFAULT 0;
    DECLARE varOtherIncomePrevious		DOUBLE DEFAULT 0;
    DECLARE varEBIT				DOUBLE DEFAULT 0;
    DECLARE varEBITPrevious				DOUBLE DEFAULT 0;
    DECLARE varIncomeTax		DOUBLE DEFAULT 0;
    DECLARE varIncomeTaxPrevious		DOUBLE DEFAULT 0;
	DECLARE varOtherTax			DOUBLE DEFAULT 0;
    DECLARE  varOtherTaxPrevious			DOUBLE DEFAULT 0;
	DECLARE varProfitLoss		DOUBLE DEFAULT 0;
    DECLARE varProfitLossPrevious		DOUBLE DEFAULT 0;
	DECLARE varCurrentAssets 			DOUBLE DEFAULT 0;
    DECLARE varCurrentAssetsPrevious 			DOUBLE DEFAULT 0;
    DECLARE varFixedAssets 			DOUBLE DEFAULT 0;
    DECLARE varFixedAssetsPrevious 			DOUBLE DEFAULT 0;
    DECLARE varDeferredAssets 			DOUBLE DEFAULT 0;
    DECLARE varDeferredAssetsPrevious 			DOUBLE DEFAULT 0;
    DECLARE varCurrentLiab				DOUBLE DEFAULT 0;
     DECLARE varCurrentLiabPrevious				DOUBLE DEFAULT 0;
    DECLARE varLongTermLiab 			DOUBLE DEFAULT 0;
    DECLARE varLongTermLiabPrevious 			DOUBLE DEFAULT 0;
    DECLARE varDeferredLiab 			DOUBLE DEFAULT 0;
     DECLARE varDeferredLiabPrevious 			DOUBLE DEFAULT 0;
    DECLARE varEquity				DOUBLE DEFAULT 0;
    DECLARE varEquityPrevious				DOUBLE DEFAULT 0;
    DECLARE varTotalAsset		DOUBLE DEFAULT 0;
    DECLARE varTotalAssetPrevious		DOUBLE DEFAULT 0;
    DECLARE varTotalLiabi		DOUBLE DEFAULT 0;
    DECLARE varTotalLiabiPrevious		DOUBLE DEFAULT 0;
    DECLARE varEquityuLiabi		DOUBLE DEFAULT 0;
     DECLARE varEquityuLiabiPrevious		DOUBLE DEFAULT 0;

	-- Calculate the value and store them into the variables declared
    #varRevenue
	SELECT sum(COALESCE(jeli.debit,0)) INTO varRevenue
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'REV';
	
	#varRevenue
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varRevenuePrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'REV';
            
    #varReturnsRefundsDiscount
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varReturnsRefundsDiscounts
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'RET';       
    
    #varReturnsRefundsDiscountsPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varReturnsRefundsDiscountsPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'RET';  
    
    #varCOGS
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varCOGS
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'COGS';   

    #varCOGSPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varCOGSPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'COGS'; 

    #varGrossProfit
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varGrossProfit
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code IN ('REV', 'RET', 'COGS');
            
	   #varGrossProfitPrevious
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varGrossProfitPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code IN ('REV', 'RET', 'COGS');
            
	#varAdminExp
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varAdminExp
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'GEXP';

	#varAdminExpPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varAdminExpPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'GEXP';

    #varSellingExp
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varSellingExp
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'SEXP'; 
	
        #varSellingExpPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varSellingExpPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'SEXP'; 
            
	#varOtherExp
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varOtherExp
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OEXP'; 	   
	
    	#varOtherExpPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varOtherExpPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OEXP'; 

	#varOtherIncome
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varOtherIncome
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OI';  
             
	#varOtherIncomePreviousrevious
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varOtherIncomePrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OI'; 
            
	#varEBIT
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varEBIT
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code IN ('REV','RET', 'COGS','GEXP','SEXP','OEXP','OI');  
            
		#varEBITPrevious
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varEBITPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code IN ('REV','RET', 'COGS','GEXP','SEXP','OEXP','OI');  

	#varIncomeTax
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varIncomeTax
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'INCTAX';  
            
		#varIncomeTaxPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varIncomeTaxPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'INCTAX'; 
            
	#varOtherTax
	SELECT SUM(COALESCE(jeli.credit,0)) INTO varOtherTax
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OTHTAX';  

	# varOtherTaxPrevious
	SELECT SUM(COALESCE(jeli.credit,0)) INTO  varOtherTaxPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0
            AND ss.statement_section_code = 'OTHTAX'; 

	#varProfitLoss
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varProfitLoss
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.profit_loss_section_id <> 0;  

	#varProfitLossPrevious
	SELECT SUM(COALESCE(jeli.debit,0)) INTO varProfitLossPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.profit_loss_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.profit_loss_section_id <> 0;  
	
    #varCurrentAssets
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varCurrentAssets
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'CA'
            AND je.debit_credit_balanced = 1;
	
      #varCurrentAssetsPrevious
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varCurrentAssetsPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'CA'
            AND je.debit_credit_balanced = 1;

    #varFixedAssets
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varFixedAssets
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'FA'
            AND je.debit_credit_balanced = 1;		

    #varFixedAssetsPrevious
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varFixedAssetsPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'FA'
            AND je.debit_credit_balanced = 1;	

    #varDeferredAssets
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varDeferredAssets
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'DA'
            AND je.debit_credit_balanced = 1;

    #varDeferredAssetsPrevious
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varDeferredAssetsPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'DA'
            AND je.debit_credit_balanced = 1;

    #varCurrentLiab
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varCurrentLiab
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'CL'
            AND je.debit_credit_balanced = 1;	
            
	    #varCurrentLiabPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varCurrentLiabPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'CL'
            AND je.debit_credit_balanced = 1;

    #varLongTermLiab
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varLongTermLiab
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'LLL'
            AND je.debit_credit_balanced = 1;	
            
    #varLongTermLiabPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varLongTermLiabPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'LLL'
            AND je.debit_credit_balanced = 1;	

    #varDeferredLiab
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varDeferredLiab
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'DL'
            AND je.debit_credit_balanced = 1;
            
    #varDeferredLiabPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varDeferredLiabPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'DL'
            AND je.debit_credit_balanced = 1;

    #varEquity
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varEquity
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'EQ'
            AND je.debit_credit_balanced = 1;	
            
    #varEquityPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*1 + COALESCE(jeli.credit,0)) INTO varEquityPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code = 'EQ'
            AND je.debit_credit_balanced = 1;	

    #varTotalAsset
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varTotalAsset
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code IN ('CA','FA','DA')
            AND je.debit_credit_balanced = 1;	
            
    #varTotalAssetPrevious
	SELECT SUM(COALESCE(jeli.debit,0) - COALESCE(jeli.credit,0)) INTO varTotalAssetPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code IN ('CA','FA','DA')
            AND je.debit_credit_balanced = 1;	

    #varTotalLiabi
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varTotalLiabi
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code IN ('CL','LLL','DL')
            AND je.debit_credit_balanced = 1;
            
    #varTotalLiabiPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varTotalLiabiPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code IN ('CL','LLL','DL')
            AND je.debit_credit_balanced = 1;	
	
        #varEquityuLiabi
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varEquityuLiabi
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code NOT IN ('CA','FA','DA')
            AND je.debit_credit_balanced = 1;	
            
        #varEquityuLiabiPrevious
	SELECT SUM(COALESCE(jeli.debit,0)*-1 + COALESCE(jeli.credit,0)) INTO varEquityuLiabiPrevious
            
		FROM journal_entry_line_item AS jeli
			INNER JOIN `account` 			AS ac ON ac.account_id = jeli.account_id
			INNER JOIN journal_entry 		AS je ON je.journal_entry_id = jeli.journal_entry_id
			INNER JOIN statement_section	AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
            
		WHERE YEAR(je.entry_date) = varCalendarYear - 1
			AND ac.balance_sheet_section_id <> 0
            AND ss.statement_section_code NOT IN ('CA','FA','DA')
            AND je.debit_credit_balanced = 1;	
            
#create table
DROP TABLE IF EXISTS syosinov_tmp;

	CREATE TABLE syosinov_tmp
		(	Sl_No INT, 
			Label VARCHAR(50), 
			Current_Year VARCHAR(50),
            Previous_Year VARCHAR(50),
            YoY_Percentage_Change VARCHAR(50)
		);

	-- Insert the header for the report
	INSERT INTO syosinov_tmp 
			(Sl_No, Label, Current_Year, Previous_Year, YoY_Percentage_Change)
			VALUES (1, 'PROFIT AND LOSS STATEMENT', varCalendarYear, varCalendarYear - 1, "In USD"),
				   (2, '', '', " ", " " ),
				   (3, 'Revenue', format(varRevenue,0), format(varRevenuePrevious,0), format(((varRevenue-varRevenuePrevious)/varRevenuePrevious)*100,2)),
                   (4, 'Returns, Refunds, Discounts', format(COALESCE(varReturnsRefundsDiscounts,0),0),format(COALESCE(varReturnsRefundsDiscountsPrevious,0),2), " " ),
                   (5, 'Cost of goods sold', format(varCOGS,0),format(varCOGSPrevious,0), " "),
                   (6, 'Gross Profit (Loss)', format(varGrossProfit, 0), format(varGrossProfitPrevious, 0),format(((varGrossProfit-varGrossProfitPrevious)/varGrossProfitPrevious)*100,2)),
                   (7, 'Selling Expenses',format(COALESCE(varSellingExp,0),0), format(COALESCE(varSellingExpPrevious,0),0), " " ),
                   (8, 'Administrative Expenses',format(COALESCE(varAdminExp,0),0), format(COALESCE(varAdminExpPrevious,0),0), " "),
                   (9, 'Other Income' , format(COALESCE(varOtherIncome,0),0), format(COALESCE(varOtherIncomePrevious,0),0), " "),
                   (10, 'Other Expenses', format(COALESCE(varOtherExp,0),0), format(COALESCE(varOtherExpPrevious,0),0), " "),
                   (11, 'Earnings before interest and taxes (EBIT)', format(COALESCE(varEBIT,0),0), format(COALESCE(varEBITPrevious,0),0), format(((varEBIT-varEBITPrevious)/varEBITPrevious)*100,2)),
                   (12, 'Income Tax', format(COALESCE(varIncomeTax,0),0), format(COALESCE(varIncomeTaxPrevious,0),0), " "),
                   (13, 'Other Tax', format(COALESCE(varOtherTax,0),0), format(COALESCE( varOtherTaxPrevious,0),0), " "),
                   (14, 'Profit for the year', format(COALESCE(varProfitLoss,0),0), format(COALESCE(varProfitLossPrevious,0),0), format(((varProfitLoss-varProfitLossPrevious)/varProfitLossPrevious)*100,2)),
                   (15, "", "","",""),
                   (16, "", "","",""),
                   (17, 'BALANCE SHEET', varCalendarYear, varCalendarYear - 1, "In USD"),
				   (18, '', '', "", ""),
				   (19, 'Current Assets', format(COALESCE(varCurrentAssets, 0),0),format(COALESCE(varCurrentAssetsPrevious, 0),0),format(((varCurrentAssets-varCurrentAssetsPrevious)/varCurrentAssetsPrevious)*100,2)),
                   (20, 'Fixed Assets', format(COALESCE(varFixedAssets, 0),0),format(COALESCE(varFixedAssetsPrevious, 0),0),format(((varFixedAssets-varFixedAssetsPrevious)/varFixedAssetsPrevious)*100,2)),
                   (21, 'Deferred Assets', format(COALESCE(varDeferredAssets, 0),0), format(COALESCE(varDeferredAssetsPrevious, 0),0),format(((varDeferredAssets-varDeferredAssetsPrevious)/varDeferredAssetsPrevious)*100,2)),
                   (22, 'Total Assets', format(COALESCE(varTotalAsset, 0),0), format(COALESCE(varTotalAssetPrevious, 0),0),format(((varTotalAsset-varTotalAssetPrevious)/varTotalAssetPrevious*100),2)),
                   (23, 'Current Liabilities', format(COALESCE(varCurrentLiab, 0),0), format(COALESCE(varCurrentLiabPrevious, 0),0),format(((varCurrentLiab-varCurrentLiabPrevious)/varCurrentLiabPrevious)*100,2)),
                   (24, 'Long-term Liabilities', format(COALESCE(varLongTermLiab, 0),0),  format(COALESCE(varLongTermLiabPrevious, 0),0),format(((varLongTermLiab-varLongTermLiabPrevious)/varLongTermLiabPrevious)*100,2)),
                   (25, 'Deferred Liabilities' , format(COALESCE(varDeferredLiab, 0),0),  format(COALESCE(varDeferredLiabPrevious, 0),0),format(((varDeferredLiab-varDeferredLiabPrevious)/varDeferredLiabPrevious)*100,2)),
                   (26, 'Total Liabilities', format(COALESCE(varTotalLiabi, 0),0),  format(COALESCE(varTotalLiabiPrevious, 0),0),format(((varTotalLiabi-varTotalLiabiPrevious)/varTotalLiabiPrevious)*100,2)),
                   (27, 'Equity', format(COALESCE(varEquity, 0),0), format(COALESCE(varEquity, 0),0),format(((varEquity-varEquityPrevious)/varEquityPrevious)*100,2)),
                   (28, 'Total Equity and Liabilities', format(COALESCE(varEquityuLiabi, 0),0),  format(COALESCE(varEquityuLiabiPrevious, 0),0),format(((varEquityuLiabi-varEquityuLiabiPrevious)/varEquityuLiabiPrevious)*100,2))
;

END $$

DELIMITER ;

#call stored procedures for PL
CALL syosinov_sp(2017);
	
SELECT * FROM syosinov_tmp;




