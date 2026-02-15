${msg("emailVerificationSubject")}

${msg("emailVerificationBodyHtml",user.firstName!'')}

${msg("emailVerificationBody1")}

${link}

${msg("emailVerificationBody2",linkExpiration)}

${msg("emailVerificationDisclaimer")}

© ${.now?string('yyyy')} ${realmName}. All rights reserved.
