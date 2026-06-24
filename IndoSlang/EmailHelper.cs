using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;

namespace IndoSlang
{
    public class EmailHelper
    {
        // send OTP email to user
        public static void SendOtpEmail(string toEmail, string otp)
        {
            string smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
            int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]);
            string smtpEmail = ConfigurationManager.AppSettings["SmtpEmail"];
            string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];

            string body = @"
                <div style='font-family:Arial,sans-serif;max-width:480px;margin:auto;padding:32px;background:#FAF4E8;border-radius:16px;'>
                    <h2 style='color:#3B2A1A;font-size:1.5rem;margin-bottom:8px;'>Your IndoSlang verification code</h2>
                    <p style='color:#6B4C2A;font-size:0.95rem;margin-bottom:24px;'>Use the code below to verify your email. It expires in 5 minutes.</p>
                    <div style='background:#fff;border-radius:12px;padding:20px;text-align:center;letter-spacing:0.3em;font-size:2rem;font-weight:700;color:#D97B2B;'>
                        " + otp + @"
                    </div>
                    <p style='color:#6B4C2A;font-size:0.82rem;margin-top:24px;'>If you did not request this, you can safely ignore this email.</p>
                </div>";

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(smtpEmail, "IndoSlang");
            mail.To.Add(toEmail);
            mail.Subject = "Your IndoSlang verification code";
            mail.Body = body;
            mail.IsBodyHtml = true;

            using (SmtpClient smtp = new SmtpClient(smtpHost, smtpPort))
            {
                smtp.Credentials = new NetworkCredential(smtpEmail, smtpPassword);
                smtp.EnableSsl = true;
                smtp.Send(mail);
            }
        }
    }
}