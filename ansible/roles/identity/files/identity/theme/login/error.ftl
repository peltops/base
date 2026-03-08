<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <h2>${msg("errorTitle")}</h2>
    <#elseif section = "form">
        <div class="info-content">
            <div class="error-icon">✕</div>
            
            <#if message?has_content && message.summary?has_content>
                <p class="info-message">
                    ${kcSanitize(message.summary)?no_esc}
                </p>
            <#else>
                <p class="info-message">
                    ${msg("errorTryAgain")}
                </p>
            </#if>

            <#if client?? && client.baseUrl?has_content>
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

            <#if skipLink??>
            <#else>
                <#if pageRedirectUri?has_content>
                    <div class="form-footer">
                        <p>
                            <a href="${pageRedirectUri}">${msg("backToApplication")}</a>
                        </p>
                    </div>
                </#if>
            </#if>
        </div>
    </#if>
</@layout.mainLayout>
