using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace IndoSlang
{
    public class OtpHelper
    {
        // generate cryptographically secure 6-digit OTP
        public static string GenerateNumericOtp()
        {
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                byte[] bytes = new byte[4];
                rng.GetBytes(bytes);
                int value = Math.Abs(BitConverter.ToInt32(bytes, 0)) % 900000 + 100000;
                return value.ToString();
            }
        }

        // HMAC hash the OTP using secret key
        public static string HmacOtp(string otp, string secret)
        {
            byte[] keyBytes = Encoding.UTF8.GetBytes(secret);
            byte[] otpBytes = Encoding.UTF8.GetBytes(otp);

            using (HMACSHA256 hmac = new HMACSHA256(keyBytes))
            {
                byte[] hashBytes = hmac.ComputeHash(otpBytes);
                return Convert.ToBase64String(hashBytes);
            }
        }

        // save OTP record to EmailOtp table
        public static void SaveOtpToDb(int userId, string otpHash, DateTime expiresAt)
        {
            string query = @"
                INSERT INTO EmailOtp (UserID, OtpHash, ExpiresAt, IsUsed, Attempts, CreatedAt)
                VALUES (@UserID, @OtpHash, @ExpiresAt, 0, 0, GETDATE())";

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@OtpHash", otpHash);
                    cmd.Parameters.AddWithValue("@ExpiresAt", expiresAt);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // verify OTP — returns true if valid, false with error message if not
        public static bool VerifyOtp(int userId, string otpEntered, string secret, out string errorMsg)
        {
            errorMsg = "";
            string query = @"
                SELECT OtpID, OtpHash, ExpiresAt, IsUsed, Attempts
                FROM EmailOtp
                WHERE UserID = @UserID
                ORDER BY CreatedAt DESC
                OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY";

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            errorMsg = "OTP not found.";
                            return false;
                        }

                        int otpId = Convert.ToInt32(reader["OtpID"]);
                        string otpHash = reader["OtpHash"].ToString();
                        DateTime expiry = Convert.ToDateTime(reader["ExpiresAt"]);
                        bool isUsed = Convert.ToBoolean(reader["IsUsed"]);
                        int attempts = Convert.ToInt32(reader["Attempts"]);

                        reader.Close();

                        if (isUsed)
                        {
                            errorMsg = "OTP already used.";
                            return false;
                        }

                        if (DateTime.Now > expiry)
                        {
                            errorMsg = "OTP has expired.";
                            return false;
                        }

                        if (attempts >= 5)
                        {
                            errorMsg = "Too many attempts. Please try again.";
                            return false;
                        }

                        // increment attempts before checking
                        IncrementAttempts(conn, otpId);

                        string enteredHash = HmacOtp(otpEntered, secret);

                        if (enteredHash != otpHash)
                        {
                            errorMsg = "Invalid OTP.";
                            return false;
                        }

                        // mark OTP as used so it cant be reused
                        MarkOtpAsUsed(conn, otpId);
                        return true;
                    }
                }
            }
        }

        // add 1 to attempts count
        private static void IncrementAttempts(SqlConnection conn, int otpId)
        {
            string query = "UPDATE EmailOtp SET Attempts = Attempts + 1 WHERE OtpID = @OtpID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@OtpID", otpId);
                cmd.ExecuteNonQuery();
            }
        }

        // mark OTP as used
        private static void MarkOtpAsUsed(SqlConnection conn, int otpId)
        {
            string query = "UPDATE EmailOtp SET IsUsed = 1 WHERE OtpID = @OtpID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@OtpID", otpId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}