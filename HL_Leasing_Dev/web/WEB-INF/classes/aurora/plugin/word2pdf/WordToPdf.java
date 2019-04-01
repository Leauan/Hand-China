package aurora.plugin.word2pdf;

import java.io.File;

import uncertain.core.UncertainEngine;
import uncertain.ocm.IObjectRegistry;

import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.ComThread;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;

public class WordToPdf {
	IObjectRegistry registry;
	String jacobDllPath;

	public WordToPdf(IObjectRegistry registry, String jacobDllName)
			throws Exception {
		println("获取路径开始");
		this.registry = registry;
		UncertainEngine engine = (UncertainEngine) this.registry
				.getInstanceOfType(UncertainEngine.class);
		String webInfPath = engine.getDirectoryConfig().getConfigDirectory();

		// ���jacob-1.18-x64.dll��C:\Java\jre1.7.0_79\binĿ¼ ���߰������´����������
		// D:\work\auroraProjects\MX_leasing\web\WEB-INF\server-script\jacob\jacob-1.18-x64.dll
		jacobDllPath = webInfPath + "\server-script\jacob\"" + jacobDllName;
		//C:\project\hand_leasing\web\WEB-INF\server-script\jacob
		println("获取路径开始");
		//jacobDllPath="C:\project\hand_leasing\web\WEB-INF\server-script\jacob\jacob-1.18-x64.dll";
		System.setProperty("jacob.dll.path", jacobDllPath);
		println("获取路径结束");
		System.setProperty("com.jacob.debug", "true");
	}

	public static boolean word2pdf(String inFilePath, String outFilePath) {
		System.out.println("WordתPDF��ʼ����...");
		long start = System.currentTimeMillis();
		ActiveXComponent app = null;
		Dispatch doc = null;
		boolean flag = false;
		try {
			app = new ActiveXComponent("Word.Application");
			app.setProperty("Visible", new Variant(false));
			Dispatch docs = app.getProperty("Documents").toDispatch();
			System.out.println("���ĵ���" + inFilePath);

			doc = Dispatch.invoke(
					docs,
					"Open",
					1,
					new Object[] { inFilePath, new Variant(false),
							new Variant(true) }, new int[1]).toDispatch();
			System.out.println("ת���ĵ���PDF��" + outFilePath);
			File tofile = new File(outFilePath);
			if (tofile.exists()) {
				tofile.delete();
			}

			Dispatch.invoke(doc, "SaveAs", 1, new Object[] { outFilePath,
					new Variant(17) }, new int[1]);
			Dispatch.call(doc, "Close", new Object[] { new Variant(false) });
			long end = System.currentTimeMillis();
			System.out.println("ת����ɣ���ʱ��" + (end - start) + "ms");
			flag = true;
		} catch (Exception e) {
			System.out.println("WordתPDF����" + e.getMessage());
			flag = false;

			System.out.println("�ر��ĵ�");
			if (app != null)
				app.invoke("Quit", 0);

			ComThread.Release();
		} finally {
			System.out.println("�ر��ĵ�");
			if (app != null)
				app.invoke("Quit", 0);

			ComThread.Release();
		}
		return flag;
	}

	public static void main(String[] args) throws Exception {
		String jacobDllPath = "E:\\Aurora\\HL_Leasing\\web\\WEB-INF\\server-script\\jacob\\jacob-1.18-x64.dll";
		System.setProperty("jacob.dll.path", jacobDllPath);
		System.setProperty("com.jacob.debug", "true");
		word2pdf("E:\\Aurora\\demo.doc", "E:\\Aurora\\demo.pdf");
	}
}
