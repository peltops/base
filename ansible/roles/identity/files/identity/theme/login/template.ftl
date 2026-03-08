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

<body class="login-pf-page">
    <!-- Top Header -->
    <div id="kc-header">
        <div id="kc-header-wrapper">${realm.displayName!''}</div>
        </div>
        
    <!-- Main Container -->
    <div id="kc-container">
        <div id="kc-container-wrapper">
            
            <!-- Alert Messages -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert alert-${message.type}">
                    ${message.summary}
                </div>
            </#if>
            
            <!-- Page Content -->
            <div id="kc-content">
                <div id="kc-content-wrapper">
                    <!-- Form Header Section -->
                    <div id="kc-form-header">
            <#nested "header">
                    </div>
            
                    <!-- Form Section -->
                    <div id="kc-form">
            <#nested "form">
                    </div>
            
                    <!-- Info Section -->
            <#if displayInfo>
                        <div id="kc-info">
                <#nested "info">
                        </div>
            </#if>
                </div>
        </div>
        
        </div>
    </div>
</body>
</html>
</#macro>
