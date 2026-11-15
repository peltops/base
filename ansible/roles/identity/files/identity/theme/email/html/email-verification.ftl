<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("emailVerificationSubject")}</title>
</head>
<body style="margin:0;padding:24px 12px;background-color:#f3f4f6;color:#151c2b;font-family:Arial,Helvetica,sans-serif;">
    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="max-width:600px;margin:0 auto;background:#ffffff;border:1px solid #dfe2e6;border-radius:14px;overflow:hidden;">
        <tr>
            <td style="padding:24px 30px;border-bottom:1px solid #dfe2e6;">
                <div style="font-size:20px;font-weight:800;letter-spacing:1px;color:#151c2b;">KUALA</div>
            </td>
        </tr>
        <tr>
            <td style="padding:34px 30px 28px;">
                <p style="margin:0 0 12px;color:#667085;font-size:12px;font-weight:bold;letter-spacing:1.5px;text-transform:uppercase;">Email verification</p>
                <h1 style="margin:0 0 16px;color:#151c2b;font-size:28px;line-height:1.2;letter-spacing:-.7px;">${msg("emailVerificationSubject")}</h1>
                <p style="margin:0 0 12px;color:#475467;font-size:15px;line-height:1.7;">${msg("emailVerificationBodyHtml",user.firstName!'')}</p>
                <p style="margin:0 0 18px;color:#475467;font-size:15px;line-height:1.7;">${msg("emailVerificationBody1")}</p>
                <p style="margin:24px 0;text-align:center;">
                    <a href="${link}" style="display:inline-block;padding:14px 26px;border:1px solid #182232;border-radius:999px;background:#182232;color:#ffffff;text-decoration:none;font-size:14px;font-weight:bold;">${msg("emailVerificationButton")}</a>
                </p>
                <p style="margin:0 0 16px;color:#667085;font-size:13px;line-height:1.7;">${msg("emailVerificationBody2",linkExpiration)}</p>
                <div style="margin-top:22px;padding:14px;border:1px solid #dfe2e6;border-radius:9px;background:#f9fafb;word-break:break-all;">
                    <p style="margin:0 0 8px;color:#667085;font-size:12px;">${msg("emailVerificationAlternative")}</p>
                    <a href="${link}" style="color:#182232;font-size:12px;line-height:1.6;word-break:break-all;">${link}</a>
                </div>
                <p style="margin:22px 0 0;color:#667085;font-size:12px;line-height:1.7;">${msg("emailVerificationDisclaimer")}</p>
            </td>
        </tr>
        <tr>
            <td style="padding:17px 30px;border-top:1px solid #dfe2e6;background:#f9fafb;color:#667085;font-size:11px;letter-spacing:1px;text-align:center;text-transform:uppercase;">
                SERI BASA DIGITAL · ${.now?string('yyyy')}
            </td>
        </tr>
    </table>
</body>
</html>
