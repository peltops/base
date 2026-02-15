<#macro mainLayout active displayMessage=true displayInfo=false displayRequiredFields=false displayWide=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="keycloak-body">
    <div class="keycloak-container">
        <div class="keycloak-header">
            <div class="logo">
                <h1>⊹ ${realm.displayName!''} ⊹</h1>
            </div>
        </div>
        
        <div class="keycloak-content">
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert alert-${message.type}">
                    <#if message.type = 'success'>
                        <span class="icon">✓</span>
                    </#if>
                    <#if message.type = 'error'>
                        <span class="icon">✕</span>
                    </#if>
                    <#if message.type = 'warning'>
                        <span class="icon">⚠</span>
                    </#if>
                    <#if message.type = 'info'>
                        <span class="icon">ℹ</span>
                    </#if>
                    <span class="message">${kcSanitize(message.summary)}</span>
                </div>
            </#if>
            
            <#nested "header">
            
            <#nested "form">
            
            <#if displayInfo>
                <#nested "info">
            </#if>
        </div>
        
        <div class="keycloak-footer">
            <p>&copy; ${.now?string('yyyy')} ${realm.displayName!''}. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
</#macro>
