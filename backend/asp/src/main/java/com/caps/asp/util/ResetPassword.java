package com.caps.asp.util;

import java.security.SecureRandom;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class ResetPassword {
    public String sendEmail(String toEmailAddress) {
        String userName = "accommodation.sharing.platform@gmail.com";
        String password = "CapstoneFall2018";
        String emailSubject = "Reset Password";
        String emailMessage = getPassword();
        try {
            // Use javamail api, set parameters from registration.properties file
            // set the session properties
            Properties props = System.getProperties();
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.required", "true");
            Session session = Session.getDefaultInstance(props, null);
            // Create email message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(userName));
            InternetAddress recipientAddress = new InternetAddress(toEmailAddress);

            message.setRecipient(Message.RecipientType.TO, recipientAddress);
            message.setSubject(emailSubject);
            message.setContent(
                    "<h1>This is your new password</h1>"+"<p>"+ emailMessage +"</p>",
                    "text/html");
//            message.setContent("<p>"+ emailMessage +"</p>", "text/html");
            // Send smtp message
            Transport tr = session.getTransport("smtp");
            tr.connect("smtp.gmail.com", 587, userName, password);
            message.saveChanges();
            tr.sendMessage(message, message.getAllRecipients());
            tr.close();
            return emailMessage;
        } catch (MessagingException e) {
            return "Error in method sendEmailNotification: " + e;
        }
    }

    public String getPassword() {
        SecureRandom random = new SecureRandom();

        final String ALPHA_CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        final String ALPHA = "abcdefghijklmnopqrstuvwxyz";
        final String NUMERIC = "0123456789";

        int len = 6;
        String dic = ALPHA_CAPS + ALPHA + NUMERIC;

        String result = "";
        for (int i = 0; i < len; i++) {
            int index = random.nextInt(dic.length());
            result += dic.charAt(index);
        }
        return result;
    }
}
