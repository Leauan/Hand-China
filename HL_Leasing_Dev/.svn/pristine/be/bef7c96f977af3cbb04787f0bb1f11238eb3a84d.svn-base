<w:tbl>
    <w:tblPr>
        <w:tblW w:w="${table.width}" w:type="${table.widthType}"/>
        <w:tblBorders>
            <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:left w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:bottom w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:right w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideH w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideV w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
        </w:tblBorders>
        <w:tblLook w:val="04A0"/>
    </w:tblPr>
    <w:tr wsp:rsidR="009218E6" wsp:rsidTr="002F7C05">
        <#list columns as column>
        <w:tc>
            <w:tcPr>
                <w:tcW w:w="${column.width!100}" w:type="pct"/> 
                <w:shd w:val="clear" w:color="auto" w:fill="D9D9D9"/>
                <w:vAlign w:val="center"/>
            </w:tcPr>
            <w:p wsp:rsidR="009218E6" wsp:rsidRPr="002F7C05" wsp:rsidRDefault="000D173B" wsp:rsidP="00F35F5B">
                <w:pPr>
                    <w:jc w:val="center"/>
                </w:pPr>
                <w:r wsp:rsidRPr="002F7C05">
                    <w:rPr>
                        <w:rFonts w:ascii="宋体" w:h-ansi="宋体" w:hint="fareast"/>
                        <wx:font wx:val="宋体"/>
                        <w:b/>
                        <w:sz w:val="18"/>
                        <w:sz-cs w:val="18"/>
                    </w:rPr>
                    <w:t>${column.title!}</w:t>
                </w:r>
            </w:p>
        </w:tc>
        </#list>
    </w:tr>
    <#list records as record>
          <w:tr wsp:rsidR="009218E6" wsp:rsidTr="00F35F5B">
            <#list columns as column>
            <w:tc>
                <w:p wsp:rsidR="009218E6" wsp:rsidRPr="002F7C05" wsp:rsidRDefault="002733E9">
                    <w:pPr>
                        <w:jc w:val="${column.align}"/>
                    </w:pPr>
                    <w:r>
                        <w:rPr>
                            <w:rFonts w:ascii="宋体" w:h-ansi="宋体" w:hint="fareast"/>
                            <wx:font wx:val="宋体"/>
                            <w:sz w:val="18"/>
                            <w:sz-cs w:val="18"/>
                        </w:rPr>
                        <w:t>${record[column.name!]}</w:t>
                    </w:r>
                </w:p>
            </w:tc>
            </#list>
        </w:tr>                                    
    </#list>            
</w:tbl>