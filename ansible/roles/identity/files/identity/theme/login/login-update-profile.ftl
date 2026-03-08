<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=!messagesPerField.existsError('username','email','firstName','lastName'); section>
    <#if section = "header">
        <h2>${msg("loginProfileTitle")}</h2>
        <p class="subtitle">${msg("loginProfileDescription")}</p>
    <#elseif section = "form">
        <form id="kc-update-profile-form" class="auth-form" action="${url.loginAction}" method="post">
            
            <#if user.editUsernameAllowed>
                <div class="form-group ${messagesPerField.printIfExists('username','has-error')}">
                    <label for="username" class="form-label">${msg("username")}</label>
                    <input type="text" 
                           id="username" 
                           class="form-input" 
                           name="username" 
                           value="${(user.username!'')}" 
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                    <#if messagesPerField.existsError('username')>
                        <span class="input-error" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <div class="form-group ${messagesPerField.printIfExists('email','has-error')}">
                <label for="email" class="form-label">${msg("email")}</label>
                <input type="email" 
                       id="email" 
                       class="form-input" 
                       name="email" 
                       value="${(user.email!'')}" 
                       <#if user.editEmailAllowed>
                           aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                       <#else>
                           readonly="readonly"
                       </#if>
                       />
                <#if messagesPerField.existsError('email')>
                    <span class="input-error" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="form-group ${messagesPerField.printIfExists('firstName','has-error')}">
                <label for="firstName" class="form-label">${msg("firstName")}</label>
                <input type="text" 
                       id="firstName" 
                       class="form-input" 
                       name="firstName" 
                       value="${(user.firstName!'')}" 
                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>" />
                <#if messagesPerField.existsError('firstName')>
                    <span class="input-error" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="form-group ${messagesPerField.printIfExists('lastName','has-error')}">
                <label for="lastName" class="form-label">${msg("lastName")}</label>
                <input type="text" 
                       id="lastName" 
                       class="form-input" 
                       name="lastName" 
                       value="${(user.lastName!'')}" 
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
                <#if messagesPerField.existsError('lastName')>
                    <span class="input-error" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="form-actions">
                <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                <button type="submit" class="btn btn-primary btn-block">
                    ${msg("doSubmit")}
                </button>
            </div>
        </form>
    </#if>
</@layout.mainLayout>
