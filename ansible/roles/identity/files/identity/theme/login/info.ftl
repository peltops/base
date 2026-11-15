<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            <h2>${messageHeader}</h2>
        <#elseif message?has_content && message.summary?has_content>
            <h2>${kcSanitize(message.summary)?no_esc}</h2>
        <#else>
            <h2>${msg("emailVerifiedTitle")}</h2>
        </#if>
    <#elseif section = "form">
        <div class="info-content">
            <#if requiredActions?? && requiredActions?seq_contains("VERIFY_EMAIL")>
                <div class="success-icon" aria-hidden="true">✓</div>
                <h3>${msg("emailVerifiedTitle")}</h3>
                <p class="success-message">${msg("emailVerifiedMessage")}</p>
            <#elseif message?has_content>
                <#if message.type == 'success'>
                    <div class="success-icon" aria-hidden="true">✓</div>
                <#elseif message.type == 'warning'>
                    <div class="warning-icon" aria-hidden="true">⚠</div>
                <#elseif message.type == 'error'>
                    <div class="error-icon" aria-hidden="true">✕</div>
                <#else>
                    <div class="info-icon-default" aria-hidden="true">ℹ</div>
                </#if>
                <p class="info-message">${kcSanitize(message.summary)?no_esc}</p>
            <#else>
                <div class="success-icon" aria-hidden="true">✓</div>
                <h3>${msg("emailVerifiedTitle")}</h3>
                <p class="success-message">${msg("emailVerifiedMessage")}</p>
            </#if>

            <#if skipLink??>
                <div class="redirect-notice">
                    <p>${msg("redirectingMessage")}</p>
                    <div class="spinner" role="status" aria-label="${msg("redirectingMessage")}"></div>
                </div>
            <#elseif pageRedirectUri?has_content>
                <div class="form-actions">
                    <a href="${pageRedirectUri}" class="btn btn-primary btn-block">${msg("backToApplication")}</a>
                </div>
            <#elseif actionUri?has_content>
                <div class="form-actions">
                    <a href="${actionUri}" class="btn btn-primary btn-block">${msg("proceedWithAction")}</a>
                </div>
            <#elseif client?? && (client.baseUrl)?has_content>
                <div class="form-actions">
                    <a href="${client.baseUrl}" class="btn btn-primary btn-block">${msg("backToApplication")}</a>
                </div>
            <#else>
                <div class="form-actions">
                    <a href="${url.loginUrl}" class="btn btn-primary btn-block">${msg("backToLogin")}</a>
                </div>
            </#if>
        </div>

        <#if skipLink?? && pageRedirectUri?has_content>
            <script>
                setTimeout(function() {
                    window.location.href = '${pageRedirectUri?js_string}';
                }, 3000);
            </script>
        </#if>
    </#if>
</@layout.mainLayout>
