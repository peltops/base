<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            <h2>${messageHeader?html}</h2>
        <#else>
            <h2>${message.summary?html}</h2>
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
                <p class="info-message">${message.summary?html}</p>
            </#if>

            <#if skipLink??>
                <div class="redirect-notice">
                    <p>${msg("redirectingMessage")}</p>
                    <div class="spinner"></div>
                </div>
            <#else>
                <#if pageRedirectUri?has_content>
                    <div class="form-actions">
                        <a href="${pageRedirectUri?html}" class="btn btn-primary btn-block">
                            ${msg("backToApplication")}
                        </a>
                    </div>
                <#elseif actionUri?has_content>
                    <div class="form-actions">
                        <a href="${actionUri?html}" class="btn btn-primary btn-block">
                            ${msg("proceedWithAction")}
                        </a>
                    </div>
                <#elseif (client.baseUrl)?has_content>
                    <div class="form-actions">
                        <a href="${client.baseUrl?html}" class="btn btn-primary btn-block">
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
                    window.location.href = ${pageRedirectUri?js_string};
                }, 3000);
            </script>
        </#if>
    </#if>
</@layout.mainLayout>
