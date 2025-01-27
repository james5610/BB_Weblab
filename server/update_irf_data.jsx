const Excel = require('exceljs');


const update_irf_data = async () => {
    var workbook = new Excel.Workbook();
    await workbook.xlsx.readFile('./server/econ_model/data/output_data/simulation_full_irfs_weblab.xlsx').then(() => {
        worksheet = workbook.getWorksheet(1);

        data = {};

        // Iterate through each column in the worksheet
        worksheet.columns.forEach((col, colNumber) => {
        data[col.values.slice(1,2)] = (col.values.slice(2)); // Create object where each attribute is column's data
        });
    });
    return data
}

module.exports = {update_irf_data};