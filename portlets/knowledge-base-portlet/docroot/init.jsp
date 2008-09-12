<%
/**
 * Copyright (c) 2000-2008 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="com.liferay.documentlibrary.service.DLServiceUtil" %>
<%@ page import="com.liferay.kb.knowledgebase.ArticleTitleException" %>
<%@ page import="com.liferay.kb.knowledgebase.ArticleVersionException" %>
<%@ page import="com.liferay.kb.knowledgebase.KnowledgeBaseKeys" %>
<%@ page import="com.liferay.kb.knowledgebase.NoSuchArticleException" %>
<%@ page import="com.liferay.kb.knowledgebase.model.KBArticle" %>
<%@ page import="com.liferay.kb.knowledgebase.model.KBArticleResource" %>
<%@ page import="com.liferay.kb.knowledgebase.model.KBFeedbackEntry" %>
<%@ page import="com.liferay.kb.knowledgebase.model.KBFeedbackStats" %>
<%@ page import="com.liferay.kb.knowledgebase.portlet.KnowledgeBaseFriendlyURLMapper" %>
<%@ page import="com.liferay.kb.knowledgebase.service.KBArticleLocalServiceUtil" %>
<%@ page import="com.liferay.kb.knowledgebase.service.KBArticleResourceLocalServiceUtil" %>
<%@ page import="com.liferay.kb.knowledgebase.service.KBArticleServiceUtil" %>
<%@ page import="com.liferay.kb.knowledgebase.service.permission.KBArticlePermission" %>
<%@ page import="com.liferay.kb.knowledgebase.service.permission.KBPermission" %>
<%@ page import="com.liferay.kb.knowledgebase.util.comparator.ArticleVersionComparator" %>
<%@ page import="com.liferay.kb.knowledgebaseaggregator.util.KnowledgeBaseAggregatorUtil" %>
<%@ page import="com.liferay.kb.util.PortletPrefsPropsUtil" %>
<%@ page import="com.liferay.kb.util.PortletPropsKeys" %>
<%@ page import="com.liferay.kb.util.RSSUtil" %>
<%@ page import="com.liferay.portal.kernel.bean.BeanParamUtil" %>
<%@ page import="com.liferay.portal.kernel.dao.search.ResultRow" %>
<%@ page import="com.liferay.portal.kernel.dao.search.RowChecker" %>
<%@ page import="com.liferay.portal.kernel.dao.search.SearchContainer" %>
<%@ page import="com.liferay.portal.kernel.dao.search.SearchEntry" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayWindowState" %>
<%@ page import="com.liferay.portal.kernel.search.Document" %>
<%@ page import="com.liferay.portal.kernel.search.Field" %>
<%@ page import="com.liferay.portal.kernel.search.Hits" %>
<%@ page import="com.liferay.portal.kernel.servlet.ImageServletTokenUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ArrayUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.DateFormats" %>
<%@ page import="com.liferay.portal.kernel.util.DiffResult" %>
<%@ page import="com.liferay.portal.kernel.util.DiffUtil" %>
<%@ page import="com.liferay.portal.kernel.util.DocumentConversionUtil" %>
<%@ page import="com.liferay.portal.kernel.util.FileUtil" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ListUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PrefsPropsUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropsUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ page import="com.liferay.portal.kernel.util.UnicodeFormatter" %>
<%@ page import="com.liferay.portal.kernel.util.WebKeys" %>
<%@ page import="com.liferay.portal.kernel.log.Log" %>
<%@ page import="com.liferay.portal.kernel.log.LogFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.model.Company" %>
<%@ page import="com.liferay.portal.model.CompanyConstants" %>
<%@ page import="com.liferay.portal.model.Group" %>
<%@ page import="com.liferay.portal.model.Layout" %>
<%@ page import="com.liferay.portal.model.LayoutConstants" %>
<%@ page import="com.liferay.portal.model.Organization" %>
<%@ page import="com.liferay.portal.model.OrganizationConstants" %>
<%@ page import="com.liferay.portal.model.Portlet" %>
<%@ page import="com.liferay.portal.model.User" %>
<%@ page import="com.liferay.portal.security.auth.PrincipalException" %>
<%@ page import="com.liferay.portal.security.permission.ActionKeys" %>
<%@ page import="com.liferay.portal.service.CompanyLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.GroupLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.LayoutLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.OrganizationLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.PortletLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.SubscriptionLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="com.liferay.portal.util.PortletKeys" %>
<%@ page import="com.liferay.portlet.PortletPreferencesFactoryUtil" %>
<%@ page import="com.liferay.portlet.tags.NoSuchEntryException" %>
<%@ page import="com.liferay.portlet.tags.NoSuchPropertyException" %>
<%@ page import="com.liferay.portlet.tags.model.TagsAsset" %>
<%@ page import="com.liferay.portlet.tags.model.TagsEntry" %>
<%@ page import="com.liferay.portlet.tags.model.TagsProperty" %>
<%@ page import="com.liferay.portlet.tags.service.TagsAssetServiceUtil" %>
<%@ page import="com.liferay.portlet.tags.service.TagsAssetLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.tags.service.TagsEntryLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.tags.service.TagsPropertyLocalServiceUtil" %>
<%@ page import="com.liferay.util.MathUtil" %>
<%@ page import="com.liferay.util.TextFormatter" %>
<%@ page import="com.liferay.util.portlet.PortletProps" %>

<%@ page import="java.io.StringReader" %>

<%@ page import="javax.portlet.ActionRequest" %>
<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="javax.portlet.PortletURL" %>
<%@ page import="javax.portlet.RenderResponse" %>
<%@ page import="javax.portlet.ResourceURL" %>
<%@ page import="javax.portlet.WindowState" %>

<%@ page import="java.text.DateFormat" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>

<portlet:defineObjects />

<liferay-theme:defineObjects />

<%
String currentURL = PortalUtil.getCurrentURL(request);
String layoutFriendlyURL = PortalUtil.getLayoutFriendlyURL(layout, themeDisplay);

Group group = GroupLocalServiceUtil.getGroup(scopeGroupId);

Organization organization = null;
User user2 = null;

if (group.isOrganization()) {
	organization = OrganizationLocalServiceUtil.getOrganization(group.getClassPK());
}
else if (group.isUser()) {
	user2 = UserLocalServiceUtil.getUserById(group.getClassPK());
}

DateFormat dateFormatDateTime = DateFormats.getDateTime(locale, timeZone);
%>