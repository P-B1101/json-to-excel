importScripts("https://cdn.sheetjs.com/xlsx-0.19.0/package/dist/xlsx.full.min.js");

async function createBlob(blob) {
    try {
        const url = URL.createObjectURL(blob);
        return url;
    } catch (e) {
        console.log(e);
        return null;
    }
}

async function createExcel(data) {
    try {
        var workbook = XLSX.utils.book_new(),
            worksheet = XLSX.utils.aoa_to_sheet(data[0]);
        workbook.SheetNames.push(data[1]);
        workbook.Sheets[data[1]] = worksheet;
        // (C3) TO BINARY STRING
        var xlsbin = XLSX.write(workbook, {
            bookType: "xlsx",
            type: "binary"
        });

        // (C4) TO BLOB OBJECT
        var buffer = new ArrayBuffer(xlsbin.length),
            array = new Uint8Array(buffer);
        for (var i = 0; i < xlsbin.length; i++) {
            array[i] = xlsbin.charCodeAt(i) & 0XFF;
        }
        var xlsblob = new Blob([buffer], { type: "application/octet-stream" });
        delete array; delete buffer; delete xlsbin;
        return xlsblob;
    }
    catch (e) {
        console.log(e);
        return null;
    }

}

async function parseExcel(data) {
    var reader = new FileReader();
    try {
        var promise = new Promise((resolutionFunc, rejectionFunc) => {
            var d = data[0];
            var result = [];
            reader.onload = function (e) {
                var mData = e.target.result;
                var workbook = XLSX.read(mData, {
                    type: 'binary'
                });
                workbook.SheetNames.forEach(function (sheetName) {
                    var sheet = workbook.Sheets[sheetName];
                    console.log(sheet);
                    var XL_row_object = XLSX.utils.sheet_to_row_object_array(sheet);
                    var json_object = JSON.stringify(XL_row_object);
                    result.push(json_object);
                });
                resolutionFunc(result);
            }
            reader.onerror = function (ex) {
                console.log(ex);
            };

            reader.readAsBinaryString(d);
        });
        return await promise.then((val) => val);
    } catch (error) {
        console.log(error);
        return null;
    }
};