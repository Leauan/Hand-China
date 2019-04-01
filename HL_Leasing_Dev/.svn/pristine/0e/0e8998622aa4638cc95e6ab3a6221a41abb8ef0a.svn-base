function seal(file_name, file_path) {
	importPackage(com.kinggrid.pdf.executes);
	importPackage(Packages.com.kinggrid.pdf);
	importPackage(Packages.java.io);
	importPackage(Packages.java.util);

	var pdf_key_path = '/home/hls/rd_dev/web/WEB-INF/server-script/kinggrid/';
	var pdf_key_name = pdf_key_path + 'iSignature.key';
	var pdf_key_exists = 'Y';
	var sign_path = file_path + '_sign';
	var hummer = null;
	var fileOutputStream = null;

	try {
		fileOutputStream = new FileOutputStream(sign_path);
		hummer = KGPdfHummer.createInstance(file_path, null, true,
				fileOutputStream, true);

		var pdfElectronicSeal4KG = new PdfElectronicSeal4KG(pdf_key_name, 0,
				"123456");

		function hummer_do_execute(text) {
			pdfElectronicSeal4KG.setText(text);
			hummer.addExecute(pdfElectronicSeal4KG);
			try {
				// 捕捉没有盖章字样的pdf
				hummer.doExecute();
				return true;
			} catch (e) {
				println(e + ":" + text);
				return false;
			}
		}
		if (!hummer_do_execute("出租人（签章）")) {
			if(!hummer_do_execute("联系电话：")){
				pdf_key_exists == 'N';
			}
			
		}

		if (pdf_key_exists == 'N') {
			$ctx.parameter.sign_status = false;
		} else {
			$ctx.parameter.sign_status = true;
		}
	} catch (e) {
		raise_app_error(e);
	} finally {
		if (fileOutputStream != null) {
			fileOutputStream.close();
		}
		if (hummer != null)
			hummer.close();
		// new File(file_name).delete();
	}
	return sign_path;
}