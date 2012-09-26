<%inherit file="base.mako" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    ${self.head()}
  </head>
  <body>

	<!-- ClickTale Top part -->
	<script type="text/javascript">
	  var WRInitTime=(new Date()).getTime();
	</script>
	<!-- ClickTale end of Top part -->

    <div id="content">
      
	  <div id="maincontent">
		<div class="innertube">
		  
		  ${self.header()}
		  <div id="main_block">
			<div id="prose_block">
			  ${next.body()}
			</div>
		  </div>
		</div>
	  </div>

	  <div id="footer">
        ${self.footer()}
      </div> <!-- End Footer -->
    </div> <!-- End Content -->

	<!-- ClickTale Bottom part -->
	<div id="ClickTaleDiv" style="display: none;"></div>
	<script type="text/javascript">
	  if(document.location.protocol!='https:')
	  document.write(unescape("%3Cscript%20src='http://s.clicktale.net/WRd.js'%20type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
	  if(typeof ClickTale=='function') ClickTale(11147,1,"www07");
	</script>
	<!-- ClickTale end of Bottom part -->

  </body>
</html>
<%def name="head()">
  <%include file="head.mako" />
</%def>
<%def name="header()">
  <%include file="header.mako" />
</%def>
<%def name="footer()">
  <%include file="footer.mako" />
</%def>
