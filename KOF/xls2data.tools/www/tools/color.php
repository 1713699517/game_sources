<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<H3><A id=hexcolors name=hexcolors>十六进制颜色值</A></H3>
<P>值"#FF9999"是由红绿蓝三原色组成的颜色，#号后的两位表示红，其后的两位为绿，最后的两位为蓝。</P>
<SCRIPT type=text/javascript>

 

function updateHex()
{
    var red = parseInt(document.forms.colorcalc.red.value);
    var green = parseInt(document.forms.colorcalc.green.value);
    var blue = parseInt(document.forms.colorcalc.blue.value);
    document.forms.colorcalc.hexcolor.value =
      "#" + Color2Hex(red)+Color2Hex(green)+Color2Hex(blue);
}

function Color2Hex(n)
{
    return ToHex(n >> 4) + ToHex(n);
}

function ToHex(n)
{
    n = n % 16;

    if (n <= 0)
        return "0";

    if (n < 10)
        return n.toString();

    if (n == 10)
        return "A";

    if (n == 11)
        return "B";

    if (n == 12)
        return "C";

    if (n == 13)
        return "D";

    if (n == 14)
        return "E";

    if (n == 15)
        return "F";
}   

function CheckDecimal(s)
{
    var n = parseInt(s);
    var i, c;

    for (i = 0; i < s.length; ++i)
    {
        c = s.charAt(i);

        if (c < '0' || '9' < c)
        {
            alert("Please enter a value between 0 and 255");
            return false;
        }
    }

    if (n < 0 || 255 < n)
    {
        alert("Please enter a value between 0 and 255");
        return false;
    }

    return true;
}

function CheckHex(s)
{
    if (!isHexColor(s))
    {
        alert("Please enter a value starting with '#' followed" +
        "\nby 6 hexadecimal digits, for example: #00FF66");
        return false;
    }

    return true;
}

function isHexColor(s)
{
    var i, c;

    if (s.charAt(0) != '#' || s.length != 7)
        return false;

    for (i = 1; i < 7; ++i)
    {
        c = s.charAt(i);

        if ('0' <= c && c <= '9')
            continue;

        if ('A' <= c && c <= 'F')
            continue;

        if ('a' <= c && c <= 'f')
            continue;

        return false;  // bad character
    }

    return true;
}

function updateRGB()
{
    var s = document.forms.colorcalc.hexcolor.value;

    if (CheckHex(s))
    {
        var red = HexColor2Decimal(s, 1);
        var green = HexColor2Decimal(s, 3);
        var blue = HexColor2Decimal(s, 5);
        document.forms.colorcalc.red.value = red.toString();
        document.forms.colorcalc.green.value = green.toString();
        document.forms.colorcalc.blue.value = blue.toString();
    }
}

function HexColor2Decimal(s, n)
{
    return 16 * HexDigit2Dec(s.charAt(n))
            + HexDigit2Dec(s.charAt(n+1));
}

// called with hex character
function HexDigit2Dec(hex)
{
    if ('0' <= hex && hex <= '9')
        return parseInt(hex);

    if (hex == 'A' || hex == 'a')
        return 10;

    if (hex == 'B' || hex == 'b')
        return 11;

    if (hex == 'C' || hex == 'c')
        return 12;

    if (hex == 'D' || hex == 'd')
        return 13;

    if (hex == 'E' || hex == 'e')
        return 14;

    if (hex == 'F' || hex == 'f')
        return 15;
    return 0;
}

 

</SCRIPT>

<CENTER>
<FORM name=colorcalc action="">
<TABLE cellSpacing=0 cellPadding=3 border=0>
  <CAPTION>
      输入 RGB 或十六进制数值后按相应的按钮进转换
</CAPTION>
  <TBODY>
  <TR>
    <TD class=shaded align=right>red:</TD>
    <TD class=shaded><INPUT onblur=CheckDecimal(this.value) maxLength=3 size=4
      value=255 name=red></TD>
          <TD class=shaded align=middle>十六进制数值</TD>
        </TR>
  <TR>
    <TD class=shaded align=right>green:</TD>
    <TD class=shaded><INPUT onblur=CheckDecimal(this.value) maxLength=3 size=4
      value=255 name=green></TD>
    <TD class=shaded><INPUT onblur=CheckHex(this.value) maxLength=7 size=8
      value=#FFFFFF name=hexcolor></TD></TR>
  <TR>
    <TD class=shaded align=right>blue:</TD>
    <TD class=shaded><INPUT onblur=CheckDecimal(this.value) maxLength=3 size=4
      value=255 name=blue></TD>
    <TD class=shaded align=middle><INPUT onclick=updateHex() type=button value=HEX?><INPUT onclick=updateRGB() type=button value=RGB?></TD></TR></TBODY></TABLE></FORM></CENTER>

</BODY></HTML>
