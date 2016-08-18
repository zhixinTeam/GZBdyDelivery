----------------------------------------------------------------------------------------------------------------------
--  查询云天系统提货单(大票)信息
----------------------------------------------------------------------------------------------------------------------
select XCB_ID,                                --内部编号
       XCB_CardId,                            --销售卡片编号
       XCB_Origin,                            --卡片来源
       XCB_BillID,                            --来源单据号
       XCB_SetDate,                           --办理日期
       XCB_CardType,                          --卡片类型
       XCB_SourceType,                        --来源类型
       XCB_Option,                            --控制方式:0,控单价;1,控数量
       XCB_Client,                            --客户编号
       XOB_Name as XCB_ClientName,            --客户名称
       XCB_Alias,                             --客户别名
       XCB_OperMan,                           --业务员
       XCB_Area,                              --销售区域                     
       XCB_CementType as XCB_Cement,          --品种编号
       PCM_Name as XCB_CementName,            --品种名称
       XCB_LadeType,                          --提货方式    
       XCB_Number,                            --初始数量
       XCB_FactNum,                           --已开数量
       XCB_PreNum,                            --原已提量
       XCB_ReturnNum,                         --退货数量
       XCB_OutNum,                            --转出数量
       XCB_RemainNum,                         --剩余数量
       XCB_ValidS,XCB_ValidE,                 --提货有效期
       XCB_Status,                            --卡片状态:0,停用;1,启用;2,冲红;3,作废
       XCB_IsImputed,                         --卡片是否估算
       XCB_IsOnly,                            --是否一车一票
       XCB_Del,                               --删除标记:0,正常;1,删除
       XCB_Creator,                           --创建人
       pub.pub_name as XCB_CreatorNM,         --创建人名
       XCB_CDate,                             --创建时间
       XCB_Firm,                              --所属厂区
       pbf.pbf_name XCB_FirmName,             --工厂名称
       pcb.pcb_id, pcb.pcb_name               --销售片区
       
from XS_Card_Base xcb
  left join XS_Compy_Base xob on xob.XOB_ID = xcb.XCB_Client
  left join PB_Code_Material pcm on pcm.PCM_ID = xcb.XCB_CementType
  Left Join pb_code_block pcb On pcb.pcb_id=xob.xob_block
  Left Join pb_basic_firm pbf On pbf.pbf_id=xcb.xcb_firm
  Left Join PB_USER_BASE pub on pub.pub_id=xcb.xcb_creator

where rownum < 200 
  and xcb.xcb_remainnum>0
--  and PCM_Name='熟料' 
--  and XCB_CardID='07703'
--  and XCB_FactNum < XCB_OutNum
--  and XCB_SetDate > to_date('2015/09/01', 'yyyy-mm-dd')
Order By XCB_SetDate DESC

----------------------------------------------------------------------------------------------------------------------
--  查询云天系统有效的品种列表
----------------------------------------------------------------------------------------------------------------------
select * from PB_Code_Material where pcm_status=1 
  and (pcm_kind in ('2001001002004000', '2001001001001000'))
--  and (pcm_name like '%32.5%' or pcm_name like '%42.5%' or pcm_name like '%52.5%' or pcm_name like '%熟料%')

Select XCB_Number,XCB_Price,XCB_FrePrice from XS_Card_Base Where XCB_ID='10062016070310000130' Order By XCB_ID DESC

Select * From XS_Card_Freight Where XCF_Type='101' And XCF_Total>0 Order By XCF_SetDate DESC

Select * From Xs_Card_Freight Left Join XS_Card_Base on XCB_ID=XCF_Card Where XCF_Type='101' And XCF_Total>0 Order By XCF_SetDate DESC

Select * From  

Select * From Xs_Rece_Receivable Where XRC_BillID='10062016070910000165'

XRC_TOTAL=8136.00 


Select * From xs_lade_load 

select  cf_notify_outwork.*,pf_analy_outwork.*,hf_analy_outwork.*,pcd_name,pf_analy_native.*,PCM_ID,pcm_molding
                from cf_notify_outwork
                left join  pf_analy_outwork on trim(cno_cementcode) = trim(paw_analy) 
               left join hf_analy_outwork on cno_cementcode=haw_analy
                left join pb_code_material mater1 on mater1.pcm_id=paw_cement 
                left join pb_code_detail a on a.pcd_code=CNO_Cement and a.pcd_type='701' and a.pcd_del='0'
               left join pf_analy_native on PAW_Cement=PAN_Intensity    
                where paw_del='0' and
                trim(cno_cementcode) = '06160814＃91'
                
Select * From v_notify_print where paw_del='0' and
                trim(cno_cementcode) = '06160814＃91'               


