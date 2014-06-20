## HTML EMAIL

This are the best HTML Email practices that we could gather and the ones we based our templates on.


### DOCTYPE

Use XHTML doctype, as it seems to have the least inconsistencies. 

Gmail and Hotmail uses XHTML Strict, and those are the email clients that strip your doctype to replace it with theirs. It’s a good practice to use it, so when your email is read in those clients it will be exactly the same, and your design won’t suffer.

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" “http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
```

### HEAD

As commented above, Gmail change your Doctype, Html, Head and Body tags for theirs, so you can’t rely on embedded CSS. All the other email clients stick with yours, so is best to have certain things in the Head, but only if their not fundamental or can be put inline as well.

```
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>*| SUBJECT |*</title>

<style type="text/css">

/* CLIENT-SPECIFIC STYLES * ---------------------------------------------------- */

	/* Force Outlook to provide a "view in browser" menu link. */
	#outlook a {padding:0;}
	/* Force Hotmail to display emails at full width */
	.ReadMsgBody {width: 100%; background-color: #FFFAF5;}
	/* Force Hotmail to display emails at full width */
	.ExternalClass {width: 100%; background-color: #FFFAF5;}
	/* Force Hotmail to display normal line spacing */
	.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;
			}

/* GENERAL STYLES * ---------------------------------------------------- */

  /* Prevent Webkit and Windows Mobile platforms from changing default font sizes, while not breaking desktop design. */
	body{-webkit-text-size-adjust:100%; -ms-text size-adjust:100%}
	body, #bodyTable, #bodyCell{height:100% !important; margin:0; padding:0; width:100% !important;}
	img{border:0; height:auto; line-height:100%; outline:none; text-decoration:none;}
	table{border-collapse:collapse !important;}

/* IMAGES STYLES * ---------------------------------------------------- */

	/* Some sensible defaults for images  */
  img {outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;}
	a img {border:none; vertical-align: middle;padding-right: 10px;}
	p img {border:none; vertical-align: middle;padding-right: 10px;}
	.image_fix {display:block;}


/* MOBILE STYLES * ---------------------------------------------------- */

	@media only screen and (max-width: 640px)  {
		body[yahoo] .deviceWidth {width:440px!important; padding:0;}
		body[yahoo] .center {text-align: center!important;}
	}
	@media only screen and (max-width: 479px) {
		body[yahoo] .deviceWidth {width:280px!important; padding:0;}
		body[yahoo] .center {text-align: center!important;}
	}
</style>

```
### USE TABLES

Gmail and Outlook 2007/2010/2013 have poor CSS support, you’ll need to use tables as the framework of your email (nested tables are widely supported).

Set the width in each cell, not the table 

Try to have only one place with attributes, such width or style. Is best to put it in every cell instead that the table itself. 

Always specify what you want in every cell, don’t assume that the email client will figure it out.

Clients like Outlook 2007 don’t respect percentage widths, especially for nested tables, so it’s better to stick to pixels. 

If you want to add padding to each cell, use either the cellpadding attribute of the table or CSS padding for each cell, but never combine the two. 

```
<table cellspacing="0" cellpadding="10" border="0">
	<tr>
		<td width="580"></td>
	</tr>
</table> 

<table cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td width=“580" style=“padding: 10px”></td>
	</tr>
</table>
```

#### Use a container table for body background colors 

Many email clients ignore background colors specified in your CSS or the <body> tag. To work around this, wrap your entire email with a 100% width table and give that a background color. 

You can use the same approach for background images too (not supported in every email client, so you have to have a fallback color). 

```
<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td bgcolor=”#000000”>
			Your code.
		</td>
	</tr>
</table> 

```

#### Avoid unnecessary whitespace

Where possible, avoid whitespace between your <td> tags. Some email clients (Yahoo! and Outlook.com) can add additional padding above or below the cell contents, breaking your design.

### CSS AND GENERAL FONT FORMATTING

#### CSS inline 

This is almost only for Gmail. There are some free online services that move your CSS inline once it’s done (Premailer seems to be the best one), so you can design your email with embedded CSS and then use a tool to inline it.

#### No shorthands

A number of email clients don’t support them, so never set your fonts or color like this:

```
p { font:bold 1em/1.2em georgia,times,serif; } 
```

Declare the properties individually: 

```
p {
	font-weight: bold;
	font-size: 1em;
	line-height: 1.2em;
	font-family: georgia,times,serif;
} 
```

For hexadecimal colors use the hole thing: `#FFFFFF` instead of `#FFF`

#### Paragraphs 

Some email clients don’t use the inherit paragraph margin, so it’s best to declare it inline for every paragraph in your email, and if you wan’t to be extra sure, in the embedded CSS to. 

```
p { margin: 0 0 1em 0; } 
```

You can avoid paragraphs altogether and set the text formatting inline in the table cell, like this:

```
<td width="200" style="font-weight:bold; font-size:1em; line-height:1.2em; font family:georgia,'times',serif;">
	Your height sensitive text.
</td> 
```

#### Links 

Some email clients will overwrite your link colors with their defaults, so you have to set a default color in each link:

```
<a href=“http://yoursite.com/" style=“color: #CCCCCC”>LINK</a> 
```

If the link color it’s really important for your design, you should add a span with the color as well:

```
<a href="http://somesite.com/" style="color:#CCCCCC">
	<span style="color:#CCCCCC">this is a link</span>
</a> 
```

### IMAGES

Be sure no important content is suppressed by image blocking. Stick to fixed cell widths to keep your formatting in place with or without images. 

Always include the dimensions of your image 

If you don’t set the dimensions for each image, your layout can be broken for many email clients that add the dimensions they want to your image. 

The image must have the same dimensions you are declaring, if not, some email clients can use the image real size.

Use the alt text 

Providing alt text is important when your images are blocked. Sadly email clients like Outlook 2007, Outlook.com and Apple Mail don’t support alt text at all when images are blocked. 

Use the display hack for Outlook.com 

Outlook.com adds a few pixels of additional padding below images, equivalent to the descender height of surrounding text. A workaround is to set the display property like:

```
.img {display:block;} 
```

This removes the padding in Outlook.com and still gives you the predicable result in other email clients. 

Don’t use floats

Stick to the align attribute of the img tag to float images in your email, it’s the best way to ensure your layout across email clients. 

```
<img src="image.jpg" align="right"> 
```

### MOBILE

#### IOS Mail

* It needs min-width:100%.
* It needs the webkit-text-size-adjust.
*	Address/phone number style gets overridden.

#### GMAIL Android & IOS App

The Gmail app is a minified version of the Gmail web-based client. Because of this, the app suffers the same strange quirks brought on by Gmail’s stripping of the `<head>` (and, consequently, `<style>`) element.

#### Links to phones

Use the "mobile-link" class with a span tag to control what number links and what doesn't in mobile clients.

```
<span class="mobile_link">123-456-7890</span>

@media only screen and (max-device-width: 480px) {
 
If you want to only link certain numbers use these two blocks of code to "unstyle" any numbers that may be linked. The second block gives you a class to apply with a span tag to the numbers you would like linked and styled.
 
	Step 1
	a[href^="tel"], a[href^="sms"] {
		text-decoration: none;
		color: black; /* or whatever your want */
		pointer-events: none;
		cursor: default;
	}

	Step 2
	.mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
		text-decoration: default;
		color: orange !important; /* or whatever your want */
		pointer-events: auto;
		cursor: default;
	}
}
 
/* More Specific Targeting */
 
@media only screen and (min-device-width: 768px) and (max-device-width: 1024px) {
 
/* Step 1a: Repeating for the iPad */
	a[href^="tel"], a[href^="sms"] {
		text-decoration: none;
		color: blue; /* or whatever your want */
		pointer-events: none;
		cursor: default;
	}
 
	.mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
		text-decoration: default;
		color: orange !important;
		pointer-events: auto;
		cursor: default;
	}
}

```

If you’re seeing strange image behavior in Yahoo! Mail, adding align=“top” to your images can often solve this problem.


### TEST A LOT!

You should test every -not so mayor- change in the code. To simplify that, there are online tester tools, and the one we used is Litmus, because it offers pretty much all the mayor email clients (desktop, mobile, and web based)

You can try ir for 7 days for free, full features.

[Litmus](https://litmus.com/)


### Subcribing to hear bounces and complaints.

In general terms, any app that sends emails should know when the destinataries are not receiving their emails and/or when they are complaining (spam notices).

Amazon's aws-sdk lets us subscribe to events such as a bounce using SNS.

```ruby

require('aws-sdk')

sns = AWS::SNS.new(
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

# We choose a name for the topic, in this case MyApp-Bounces

arn = sns.client.create_topic({name:'MyApp-Bounces'}).topic_arn

# we retrieve the topic we just created

topic = sns.topics[arn]

# we subscribe our own url to the topic

topic.subscribe('http://example.com/messages')

# TODO: continue this documentation, check if we are already subscribed.

# Also remember to add this SNS Topic to our SES configuration for Bounces.
```

read more on Amazons documentation: http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/SNS.html


### SOURCES

We based this guide and our templates on the work of Mailchimp, Campaing Monitor, HTML Email Boilerplate and our own experience designing HTML email.

* [Mailchimp](http://templates.mailchimp.com/)
* [Campaignmonitor](http://www.campaignmonitor.com/resources/will-it-work/guidelines/)
* [Htmlemailboilerplate](http://htmlemailboilerplate.com/)
