<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            <h2>${messageHeader}</h2>
        <#else>
            <h2>${message.summary}</h2>
        </#if>
    <#elseif section = "form">
        <div class="info-content">
            <#if requiredActions??>
                <#list requiredActions as reqActionItem>
                    <#if reqActionItem == "VERIFY_EMAIL">
                        <div class="success-icon">✓</div>
                        <h3>${msg("emailVerifiedTitle")}</h3>
                        <p class="success-message">${msg("emailVerifiedMessage")}</p>
                    </#if>
                </#list>
            <#else>
                <div class="info-icon">
                    <#if message.type == 'success'>
                        <div class="success-icon">✓</div>
                    <#elseif message.type == 'warning'>
                        <div class="warning-icon">⚠</div>
                    <#elseif message.type == 'error'>
                        <div class="error-icon">✕</div>
                    <#else>
                        <div class="info-icon-default">ℹ</div>
                    </#if>
                </div>
                <p class="info-message">${kcSanitize(message.summary)?no_esc}</p>
            </#if>

            <#if skipLink??>
                <div class="redirect-notice">
                    <p>${msg("redirectingMessage")}</p>
                    <div class="spinner"></div>
                </div>
            <#else>
                <#if pageRedirectUri?has_content>
                    <div class="form-actions">
                        <a href="${pageRedirectUri}" class="btn btn-primary btn-block">
                            ${msg("backToApplication")}
                        </a>
                    </div>
                <#elseif actionUri?has_content>
                    <div class="form-actions">
                        <a href="${actionUri}" class="btn btn-primary btn-block">
                            ${msg("proceedWithAction")}
                        </a>
                    </div>
                <#elseif (client.baseUrl)?has_content>
                    <div class="form-actions">
                        <a href="${client.baseUrl}" class="btn btn-primary btn-block">
                            ${msg("backToApplication")}
                        </a>
                    </div>
                <#else>
                    <div class="form-actions">
                        <a href="${url.loginUrl}" class="btn btn-primary btn-block">
                            ${msg("backToLogin")}
                        </a>
                    </div>
                </#if>
            </#if>
        </div>

        <#if skipLink?? && pageRedirectUri?has_content>
            <script>
                setTimeout(function() {
                    window.location.href = '${pageRedirectUri}';
                }, 3000);
            </script>
        </#if>
    </#if>
</@layout.mainLayout>
