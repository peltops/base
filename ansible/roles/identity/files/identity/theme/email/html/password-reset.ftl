<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("passwordResetSubject")}</title>
    <style>
        body {
            font-family: Georgia, 'Times New Roman', serif;
            line-height: 1.6;
            color: #3d3d3d;
            margin: 0;
            padding: 0;
            background-color: #f5f1eb;
        }
        .email-container {
            max-width: 560px;
            margin: 40px auto;
            background: #faf8f3;
            border: 1px solid #d4c4b0;
            overflow: hidden;
        }
        .email-header {
            background: #8b7355;
            padding: 32px 30px;
            text-align: center;
            color: #faf8f3;
            border-bottom: 2px solid #6b5742;
        }
        .email-header h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 400;
            letter-spacing: 0.5px;
        }
        .email-body {
            padding: 36px 30px;
        }
        .email-body h2 {
            color: #3d3d3d;
            margin-top: 0;
            font-weight: 400;
            font-size: 18px;
        }
        .email-body p {
            margin: 14px 0;
            color: #6b6b6b;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            line-height: 1.6;
        }
        .reset-button {
            display: inline-block;
            padding: 12px 32px;
            margin: 24px 0;
            background: #8b7355;
            color: #faf8f3 !important;
            text-decoration: none;
            border: 1px solid #6b5742;
            font-weight: 400;
            text-align: center;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            letter-spacing: 0.3px;
        }
        .reset-button:hover {
            background: #6b5742;
        }
        .alternative-link {
            margin-top: 24px;
            padding: 16px;
            background: #f5f1eb;
            border: 1px solid #d4c4b0;
            word-break: break-all;
        }
        .alternative-link p {
            margin: 0 0 8px 0;
            font-weight: 400;
            color: #6b6b6b;
            font-size: 13px;
        }
        .alternative-link a {
            color: #8b7355;
            word-break: break-all;
            font-size: 12px;
        }
        .email-footer {
            padding: 24px 30px;
            text-align: center;
            background: #f5f1eb;
            color: #8f8f8f;
            font-size: 12px;
            border-top: 1px solid #d4c4b0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        .disclaimer {
            margin-top: 24px;
            color: #8f8f8f;
            font-size: 12px;
            font-style: italic;
            font-family: Georgia, serif;
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="email-header">
            <h1>${msg("passwordResetSubject")}</h1>
        </div>
        
        <div class="email-body">
            <h2>${msg("passwordResetBodyHtml",user.firstName!'')}</h2>
            
            <p>${msg("passwordResetBody1")}</p>
            
            <div style="text-align: center;">
                <a href="${link}" class="reset-button">${msg("passwordResetButton")}</a>
            </div>
            
            <p>${msg("passwordResetBody2",linkExpiration)}</p>
            
            <div class="alternative-link">
                <p>${msg("passwordResetAlternative")}</p>
                <a href="${link}">${link}</a>
            </div>
            
            <p class="disclaimer">${msg("passwordResetDisclaimer")}</p>
        </div>
        
        <div class="email-footer">
            <p>&copy; ${.now?string('yyyy')} ${realmName}. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
