<#import "template.ftl" as layout>
<@layout.mainLayout active='login' displayMessage=!messagesPerField.existsError('username','password'); section>
    <#if section = "header">
        <h1 id="kc-page-title">${msg("loginAccountTitle")}</h1>
        <p class="subtitle">Sign in to your account</p>
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <#if realm.password>
                    <form id="kc-form-login" class="auth-form" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                        
                        <div class="form-group ${messagesPerField.printIfExists('username','has-error')}">
                            <label for="username" class="form-label">
                                <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                            </label>
                            
                            <#if usernameHidden??>
                                <input tabindex="1" id="username" class="form-input" name="username" value="${(login.username!'')}" type="hidden" />
                            <#else>
                                <input tabindex="1" 
                                       id="username" 
                                       class="form-input" 
                                       name="username"
                                       value="${(login.username!'')}"  
                                       type="text" 
                                       autofocus 
                                       autocomplete="username"
                                       placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                            </#if>
                            
                            <#if messagesPerField.existsError('username')>
                                <span class="input-error" aria-live="polite">
                                    ${messagesPerField.get('username')?html}
                                </span>
                            </#if>
                        </div>

                        <div class="form-group ${messagesPerField.printIfExists('password','has-error')}">
                            <label for="password" class="form-label">${msg("password")}</label>
                            <input tabindex="2" 
                                   id="password" 
                                   class="form-input" 
                                   name="password" 
                                   type="password" 
                                   autocomplete="current-password"
                                   placeholder="${msg("password")}"
                                   aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" />
                            <#if messagesPerField.existsError('password')>
                                <span class="input-error" aria-live="polite">
                                    ${messagesPerField.get('password')?html}
                                </span>
                            </#if>
                        </div>

                        <div class="form-options">
                            <#if realm.rememberMe && !usernameHidden??>
                                <div class="checkbox">
                                    <label>
                                        <input tabindex="3" 
                                               id="rememberMe" 
                                               name="rememberMe" 
                                               type="checkbox"
                                               <#if login.rememberMe??>checked</#if>> 
                                        ${msg("rememberMe")}
                                    </label>
                                </div>
                            </#if>
                            <#if realm.resetPasswordAllowed>
                                <a class="forgot-password" tabindex="5" href="${url.loginResetCredentialsUrl}">
                                    ${msg("doForgotPassword")}
                                </a>
                            </#if>
                        </div>

                        <div id="kc-form-buttons" class="form-actions">
                            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                            <button tabindex="4" class="btn btn-primary btn-block" name="login" id="kc-login" type="submit">
                                ${msg("doLogIn")}
                            </button>
                        </div>
                    </form>
                </#if>
            </div>

            <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                <div class="form-footer">
                    <p>${msg("noAccount")} 
                        <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a>
                    </p>
                </div>
            </#if>
        </div>
    </#if>
</@layout.mainLayout>
