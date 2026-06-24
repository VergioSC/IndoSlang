<%@ Page Title="Verify OTP" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VerifyOtp.aspx.cs" Inherits="IndoSlang.VerifyOtp" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* page layout */
        .otp-page {
            min-height: calc(100vh - 80px);
            background: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 42px 20px;
            font-family: var(--font-body);
        }

        /* main card */
        .otp-card {
            width: 100%;
            max-width: 440px;
            background: #fff;
            border-radius: 26px;
            padding: 42px 42px 36px;
            box-shadow: 0 10px 35px rgba(59, 42, 26, 0.12);
            border: 2px solid rgba(59, 42, 26, 0.08);
            text-align: center;
        }

        .otp-icon { font-size: 3rem; margin-bottom: 14px; }

        .otp-title {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            margin: 0 0 8px;
        }

        .otp-subtitle {
            color: var(--brown-mid);
            font-size: 0.9rem;
            margin: 0 0 10px;
        }

        /* steps hint */
        .otp-steps {
            background: var(--cream);
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 24px;
            text-align: left;
        }

        .otp-steps p {
            margin: 0 0 6px;
            font-size: 0.84rem;
            color: var(--brown);
            font-weight: 700;
        }

        .otp-steps ol {
            margin: 0;
            padding-left: 18px;
            font-size: 0.82rem;
            color: var(--brown-mid);
            line-height: 1.7;
        }

        /* message boxes */
        .message-box {
            display: none;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 0.88rem;
            margin-bottom: 18px;
            text-align: left;
        }

        .message-box.error { background: #fde8e8; color: #7b1515; }
        .message-box.success { background: #d4edda; color: #1a5c2a; }
        .message-box.visible { display: block; }

        /* otp input */
        .otp-input {
            width: 100%;
            padding: 14px;
            border: 2px solid var(--cream-mid);
            border-radius: 13px;
            background: var(--cream);
            color: var(--brown);
            font-family: var(--font-display);
            font-size: 1.8rem;
            text-align: center;
            letter-spacing: 0.3em;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.18s, box-shadow 0.18s;
        }

        .otp-input:focus {
            border-color: var(--accent);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(217, 123, 43, 0.12);
        }

        /* verify button */
        .btn-verify {
            width: 100%;
            border: none;
            border-radius: 14px;
            background: var(--accent);
            color: #fff;
            padding: 14px 18px;
            font-family: var(--font-display);
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 18px;
            transition: background 0.18s, transform 0.16s;
        }

        .btn-verify:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
        }

        .resend-link {
            margin-top: 18px;
            font-size: 0.85rem;
            color: var(--brown-mid);
        }

        .resend-link a {
            color: var(--accent);
            font-weight: 700;
            text-decoration: none;
        }

        .resend-link a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="otp-page">
        <div class="otp-card">

            <div class="otp-icon">📧</div>
            <h1 class="otp-title">Verify your email</h1>
            <p class="otp-subtitle">Almost there! One last step before you start learning Indonesian slang.</p>

            <div class="otp-steps">
                <p>How to verify:</p>
                <ol>
                    <li>Open your email inbox</li>
                    <li>Look for an email from IndoSlang</li>
                    <li>Copy the 6-digit code</li>
                    <li>Paste it below and hit Verify</li>
                </ol>
            </div>

            <div class="message-box error" id="errorMsg">
                <asp:Literal ID="litError" runat="server" />
            </div>
            <div class="message-box success" id="successMsg">
                <asp:Literal ID="litSuccess" runat="server" />
            </div>

            <asp:TextBox ID="txtOtp" runat="server" CssClass="otp-input" placeholder="000000" MaxLength="6" />

            <asp:Button ID="btnVerify" runat="server" Text="Verify OTP" CssClass="btn-verify" OnClick="btnVerify_Click" />

            <div class="resend-link">
                Didn't get the code? <a href="Register.aspx">Go back and register again</a>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        window.addEventListener('DOMContentLoaded', function () {
            showServerMessages();
        });

        function showServerMessages() {
            var errorMsg = document.getElementById('errorMsg');
            var successMsg = document.getElementById('successMsg');

            if (errorMsg && errorMsg.innerText.trim() !== '')
                errorMsg.classList.add('visible');

            if (successMsg && successMsg.innerText.trim() !== '')
                successMsg.classList.add('visible');
        }
    </script>
</asp:Content>