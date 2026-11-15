<#macro mainLayout active displayMessage=true displayInfo=false displayRequiredFields=false displayWide=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, nofollow">
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
        <header class="keycloak-header">
            <div class="logo"><h1>KUALA</h1></div>
        </header>

        <main class="keycloak-content">
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert alert-${message.type}" role="alert">
                    <#if message.type = 'success'><span class="icon" aria-hidden="true">✓</span></#if>
                    <#if message.type = 'error'><span class="icon" aria-hidden="true">✕</span></#if>
                    <#if message.type = 'warning'><span class="icon" aria-hidden="true">⚠</span></#if>
                    <#if message.type = 'info'><span class="icon" aria-hidden="true">ℹ</span></#if>
                    <span class="message">${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <#nested "header">
            <#nested "form">
            <#if displayInfo><#nested "info"></#if>
        </main>

        <footer class="keycloak-footer">
            <p>SERI BASA DIGITAL</p>
        </footer>
    </div>
</body>
</html>
</#macro>
