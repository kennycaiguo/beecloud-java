<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="java.io.BufferedReader" %>
<%@page import="java.io.UnsupportedEncodingException" %>
<%@page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ page import="cn.beecloud.*" %>
<%@ page import="org.apache.log4j.*" %>
<%
    /* *
     功能：BeeCloud服务器异步通知页面
     //***********页面功能说明***********
     创建该页面文件时，请留心该页面文件中无任何HTML代码及空格。
     该页面不能在本机电脑测试，请到服务器上做测试。请确保外部可以访问该页面。
     如果没有收到该页面返回的 success 信息，BeeCloud会在36小时内按一定的时间策略重发通知
     //********************************
     * */
%>

<%!
    Logger log = Logger.getLogger(this.getClass());

      boolean verifySign(String text,String masterKey,String signature) {
        boolean isVerified = verify(text, signature, masterKey, "UTF-8");
        if (!isVerified) {
            return false;
        }
        return true;
    }


     boolean verify(String text, String sign, String key, String inputCharset) {
        text = text + key;
        String mysign = DigestUtils.md5Hex(getContentBytes(text, inputCharset));
        return mysign.equals(sign);
    }

    byte[] getContentBytes(String content, String charset) {
        if (charset == null || "".equals(charset)) {
            return content.getBytes();
        }
        try {
            return content.getBytes(charset);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("MD5签名过程中出现错误,指定的编码集不对,您目前指定的编码集是:" + charset);
        }
    }
%>

<%

    Logger log = Logger.getLogger(this.getClass());
    String appID="c5d1cba1-5e3f-4ba0-941d-9b0a371fe719";
    String testSecret="4bfdd244-574d-4bf3-b034-0c751ed34fee";
    String appSecret="39a7a518-9ac8-4a9e-87bc-7885f33cf18c";
    String masterSecret="39a7a518-9ac8-4a9e-87bc-7885f33cf18c";
    BeeCloud.registerApp(appID,testSecret, appSecret, masterSecret);
    StringBuffer json = new StringBuffer();
    String line = null;


    try {
        request.setCharacterEncoding("utf-8");
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            json.append(line);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    JSONObject jsonObj = JSONObject.fromObject(json.toString());

    String signature = jsonObj.getString("signature");
    String transactionId=jsonObj.getString("transaction_id");
    String transactionType=jsonObj.getString("transaction_type");
    String channelType=jsonObj.getString("channel_type");
    String transactionFee=jsonObj.getString("transaction_fee");

    StringBuffer toSign = new StringBuffer();
    toSign.append(BCCache.getAppID()).append(transactionId)
            .append(transactionType).append(channelType)
            .append(transactionFee);
   boolean status = verifySign(toSign.toString(),masterSecret,signature);
    if (status) { //验证成功
        out.println("success"); //请不要修改或删除

        // 此处需要验证购买的产品与订单金额是否匹配:
        // 验证购买的产品与订单金额是否匹配的目的在于防止黑客反编译了iOS或者Android app的代码，
        // 将本来比如100元的订单金额改成了1分钱，开发者应该识别这种情况，避免误以为用户已经足额支付。
        // Webhook传入的消息里面应该以某种形式包含此次购买的商品信息，比如title或者optional里面的某个参数说明此次购买的产品是一部iPhone手机，
        // 开发者需要在客户服务端去查询自己内部的数据库看看iPhone的金额是否与该Webhook的订单金额一致，仅有一致的情况下，才继续走正常的业务逻辑。
        // 如果发现不一致的情况，排除程序bug外，需要去查明原因，防止不法分子对你的app进行二次打包，对你的客户的利益构成潜在威胁。
        // 如果发现这样的情况，请及时与我们联系，我们会与客户一起与这些不法分子做斗争。而且即使有这样极端的情况发生，
        // 只要按照前述要求做了购买的产品与订单金额的匹配性验证，在你的后端服务器不被入侵的前提下，你就不会有任何经济损失。

        // 处理业务逻辑
    } else { //验证失败
        out.println("fail");
    }
%>
