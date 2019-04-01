function seal(file_name, file_path,qfz_flag) {
	importPackage(com.kinggrid.pdf.executes);
	importPackage(Packages.com.kinggrid.pdf);
	importPackage(Packages.java.io);
	importPackage(Packages.java.util);

	//var pdf_key_path = 'C:/workspace_Project/geely_new/geely_project/code/geely_Leasing/web/WEB-INF/server-script/kinggrid/';
	var pdf_key_path = '/data/geely_Leasing/web/WEB-INF/server-script/kinggrid/';
	var cert_path = pdf_key_path + 'sign.pfx';
	var pdf_key_exists = 'Y';
	var sign_path = file_path + '_sign';
	var hummer = null;
	var fileOutputStream = null;
	var cert = null;
	var Q_PdfSignature4KG = null;
	var _PdfSignature4KG = null;
	try {
		function hummer_do_execute(text) {
			cert = new FileInputStream(cert_path);
			fileOutputStream = new FileOutputStream(sign_path);
			/*hummer = KGPdfHummer.createSignature(file_path, null, true,
					fileOutputStream,
					new File("C:/pdf_tmp/"), true);*/
			hummer = KGPdfHummer.createSignature(file_path, null, true,
					fileOutputStream,
					new File("/data/geely_Leasing/pdf_tmp/"), true);
			hummer.setCertificate(cert, "11111111", "11111111");
			var auto = com.kinggrid.kgcore.enmu.KGServerTypeEnum.AUTO;
			 _PdfSignature4KG = new PdfSignature4KG("http://10.86.94.111:8089/iSignatureServer/OfficeServer.jsp",auto,"001","123456","合同专用章");  //keySN（001）为签章服务器的唯一序列号。
			_PdfSignature4KG.setText(text);
			hummer.addExecute(_PdfSignature4KG); //改成使用add任务 ，因为直接 set只能生效一种
			/*骑缝章*/
			
			if (qfz_flag == 'Y'){//如果需要加盖骑缝章
			  Q_PdfSignature4KG = new PdfSignature4KG("http://10.86.94.111:8089/iSignatureServer/OfficeServer.jsp",auto,"001","123456","合同专用章");  //keySN（001）为签章服务器的唯一序列号。
				Q_PdfSignature4KG.qfz(5, com.kinggrid.pdf.enmu.KGQfzModeEnum.ALLPAGE, 100);
				//Q_PdfSignature4KG.qfzBilateralOff(200); //去掉双侧对开
				//hummer.setPdfSignature(_PdfSignature4KG);
				hummer.addExecute(Q_PdfSignature4KG);
			}
			
			try {
				// 捕捉没有盖章字样的pdf
				hummer.doSignature();
				return true;
			} catch (e) {
				println(e + ":" + text);
				return false;
			}finally {
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
		Q_PdfSignature4KG = null;
		_PdfSignature4KG = null;
		if (hummer != null)
			hummer.close();
	}
	return sign_path;
}