importClass(Packages.java.security.SecureRandom);
importClass(Packages.javax.crypto.Cipher);
importClass(Packages.javax.crypto.KeyGenerator);
importClass(Packages.javax.crypto.spec.SecretKeySpec);
//importClass(Packages.aurora.plugin.util.Base64);

var AES = {
	encrypt : function(key, data, alg) {
		var base64 = new Packages.aurora.plugin.util.Base64(0, null, true);
		var bytes = new java.lang.String(data).getBytes('UTF-8');
		var gennerator = KeyGenerator.getInstance('AES');
		seed = SecureRandom.getInstance(alg || "SHA1PRNG");
		seed.setSeed(new java.lang.String(key).getBytes());
		gennerator.init(128, seed);
		var cipher = Cipher.getInstance('AES');
		cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(gennerator
				.generateKey().getEncoded(), 'AES'));
		bytes = cipher.doFinal(bytes);
		return String(new java.lang.String(base64.encode(bytes), 'UTF-8'));
	},

	decrypt : function(key, data, alg) {
		var base64 = new Packages.aurora.plugin.util.Base64(0, null, true);
		var bytes = bytes = base64.decodeBase64(data);
		var gennerator = KeyGenerator.getInstance('AES');
		var seed = SecureRandom.getInstance(alg || "SHA1PRNG");
		seed.setSeed(new java.lang.String(key).getBytes());
		gennerator.init(128, seed);
		var cipher = Cipher.getInstance('AES');
		cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(gennerator
				.generateKey().getEncoded(), 'AES'));
		bytes = cipher.doFinal(bytes);
		return String(new java.lang.String(bytes, 'UTF-8'));
	}
};