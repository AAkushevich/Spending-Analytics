const express = require('express'),

    authController = require('../../../controllers/apis/login/login'),
    signInController = require('../../../controllers/apis/sign_up/sign_up_controller'),
    newScoreController = require('../../../controllers/apis/new_score/new_score_controller'),
    removeScoreController = require('../../../controllers/apis/remove_score/remove_score_controller'),
    
    expenseController = require('../../../controllers/apis/expense/expense_controller'),
    incomeController = require('../../../controllers/apis/income/income_controller'),
    debtController = require('../../../controllers/apis/debt/debt_controller'),
    transferController = require('../../../controllers/apis/transfer/transfer_controller'),
    depositController = require('../../../controllers/apis/deposit/deposit_controller'),
    creditController = require('../../../controllers/apis/credit/credit_controller'),
    closeCreditController = require('../../../controllers/apis/credit/close_credit_controller'),

    deleteExpenseController = require('../../../controllers/apis/expense/delete_expense_controller'),
    deleteIncomeController = require('../../../controllers/apis/income/delete_income_controller'),
    deleteDebtController = require('../../../controllers/apis/debt/delete_debt_controller'),
    closeDebtController = require('../../../controllers/apis/debt/close_debt_controller'),

    deleteTransferController = require('../../../controllers/apis/transfer/delete_transfer_controller'),
    deleteDepositController = require('../../../controllers/apis/deposit/delete_deposit_controller'),
    deleteCreditController = require('../../../controllers/apis/credit/delete_credit_controller');
    
    fetchDataController = require('../../../controllers/apis/fetch_data/fetch_all_data');
    fetchAccountsController = require('../../../controllers/apis/fetch_data/get_accounts');
    getCategoriesController = require('../../../controllers/apis/category/category_controller');
    
    let router = express.Router();

    router.use('/login', authController);
    router.use('/sign_up', signInController);
    router.use('/new_score', newScoreController);
    router.use('/remove_score', removeScoreController);

    router.use('/new_expense', expenseController);
    router.use('/new_income', incomeController);
    router.use('/new_debt', debtController);
    router.use('/transfer', transferController);
    router.use('/deposit', depositController);
    router.use('/credit', creditController);
    router.use('/close_credit', closeCreditController);

    router.use('/delete_expense', deleteExpenseController);
    router.use('/delete_income', deleteIncomeController);
    router.use('/delete_debt', deleteDebtController);
    router.use('/close_debt', closeDebtController);

    router.use('/delete_transfer', deleteTransferController);
    router.use('/delete_deposit', deleteDepositController);
    router.use('/delete_credit', deleteCreditController);

    router.use('/fetch_all_data', fetchDataController);
    router.use('/get_accounts', fetchAccountsController);
    router.use('/get_categories', getCategoriesController);
module.exports = router;