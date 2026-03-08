<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        <h2>${msg("emailForgotTitle")}</h2>
        <p class="subtitle">${msg("emailInstruction")}</p>
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="auth-form" action="${url.loginAction}" method="post">
            
            <div class="form-group ${messagesPerField.printIfExists('username','has-error')}">
                <label for="username" class="form-label">
                    <#if !realm.loginWithEmailAllowed>
                        ${msg("username")}
                    <#elseif !realm.registrationEmailAsUsername>
                        ${msg("usernameOrEmail")}
                    <#else>
                        ${msg("email")}
                    </#if>
                </label>
                
                <input type="text" 
                       id="username" 
                       class="form-input" 
                       name="username" 
                       autofocus
                       placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                
                <#if messagesPerField.existsError('username')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('username')?html}
                    </span>
                </#if>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-block">
                    ${msg("doSubmit")}
                </button>
            </div>
        </form>

        <div class="form-footer">
            <p>
                <a href="${url.loginUrl}">${msg("backToLogin")}</a>
            </p>
        </div>
    </#if>
</@layout.mainLayout>
