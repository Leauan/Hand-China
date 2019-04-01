function seal(file_name, file_path) {
	importPackage(com.kinggrid.pdf.executes);
	importPackage(Packages.com.kinggrid.pdf);
	importPackage(Packages.java.io);
	importPackage(Packages.java.util);

	var pdf_key_path = '/data/geely_Leasing/web/WEB-INF/server-script/kinggrid/';
	/*var pdf_key_name = pdf_key_path + 'iSignature_prod.key';*/
	var cert_path = pdf_key_path + 'sign.pfx';
	var pdf_key_exists = 'Y';
	var sign_path = file_path + '_sign';
	var hummer = null;
	var fileOutputStream = null;
	var cert = null;

	try {
		//PdfElectronicSeal4KG 
		function hummer_do_execute(text) {
			cert = new FileInputStream(cert_path);
			fileOutputStream = new FileOutputStream(sign_path);
			hummer = KGPdfHummer.createSignature(file_path, null, true,
					fileOutputStream,
					new File("/data/geely_Leasing/pdf_tmp/"), true);
			hummer.setCertificate(cert, "1111111", "11111111");
			var pdfSignature4KG = new pdfSignature4KG("http://10.86.94.111:8089/iSignatureServer/OfficeServer.jsp",KGServerTypeEnum.AUTO,"001","123456","合同专用章");  //keySN（001）为签章服务器的唯一序列号。
			//var pdfSignature4KG = new PdfSignature4KG(pdf_key_name, 0, "123456");
			pdfSignature4KG.setText(text);
			hummer.setPdfSignature(pdfSignature4KG);
			try {
				// 捕捉没有盖章字样的pdf
				hummer.doSignature();
				return true;
			} catch (e) {
				println(e + ":" + text);
				return false;
			}
		}
		/*if (!hummer_do_execute("出租人（签章）")) {
			if (!hummer_do_execute("授权单位（印章）")) {
				var flag = hummer_do_execute("抵押权人盖章/电子签章");
				if (!flag) {
					pdf_key_exists == 'N';
				}
			}
		}*/
		if (!hummer_do_execute("合同签章")) {
			if (!hummer_do_execute("授权单位（印章）")) {
				var flag = hummer_do_execute("抵押权人盖章/电子签章");
				if (!flag) {
					pdf_key_exists == 'N';
				}
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
		if (cert != null) {
			cert.close();
		}
		if (hummer != null)
			hummer.close();
		// new File(file_name).delete();
	}
	return sign_path;
}