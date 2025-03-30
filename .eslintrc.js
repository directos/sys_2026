module.exports = {
    "env": {
        "browser": true,
        "es2021": true,
        "es6": true,
        "commonjs": true,
        "jquery": true,
    },
    "extends": "eslint:recommended",
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "rules": {
        "no-unused-vars": ["warn", { "vars": "all", "args": "none", "ignoreRestSiblings": false }]
    },
    "globals": {
        "google": false,
        "LogRocket": false,
        "Rollbar": false,
        "Offline": false,
        "jwt_decode": false,
        "Dexie": false,
        "jsPDF": false,
        "printJS": false,
        "Chart": false,
        "QRCode": false,
        "JsBarcode": false,
        "html2canvas": false,
        "SignaturePad": false,
        "PDFObject": false,
        "process": false,
        "Fuse": false,
        "odoo": false,
    }
}
