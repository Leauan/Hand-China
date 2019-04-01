create or replace function days_between(p_data_from  date,
                                        p_data_to    date,
                                        p_days_per   number default 31,
                                        p_method     number default 1) return number is
  /*
   p_days_per = 31 :  ÿ��31�죬�������
   p_days_per = 30 :  ÿ��30��
  */

  v_data_from  date;
  v_data_to    date;
  v_data_n     date;

  v_days       number := 0;
  v_days_n     number;
  v_sign       number;
  
  i            number:=0;
  
  v_from_yyyy  number;
  v_from_mm    number;
  v_from_dd    number;
  
  v_to_yyyy    number;
  v_to_mm      number;
  v_to_dd      number;
  
  v_tmp_yyyy    number;
  v_tmp_mm      number;
  v_tmp_dd      number;
begin
  v_data_from := trunc(p_data_from);
  v_data_to   := trunc(p_data_to);

  if v_data_from = v_data_to then
    v_days := 0;
    return v_days;
  end if;


  if p_days_per = 31 then
    v_days := v_data_to - v_data_from;
  end if;


  if p_days_per = 30 then


    if v_data_from < v_data_to then
      v_sign := 1;
    else
      v_data_n := v_data_from;
      v_data_from := v_data_to;
      v_data_to := v_data_n;

      v_sign := -1;
    end if;
    
    --��ʼ������
    v_from_yyyy := to_char(v_data_from,'yyyy');
    v_from_mm := to_char(v_data_from,'mm');
    v_from_dd := to_char(v_data_from,'dd');
      
    v_to_yyyy := to_char(v_data_to,'yyyy');
    v_to_mm := to_char(v_data_to,'mm');
    v_to_dd := to_char(v_data_to,'dd');
    
    
    if nvl(p_method,1) = 1 then
      --ŷ�޷����������ʼ���ں���ֹ����Ϊĳ�µ� 31 �ţ�����ڵ��µ� 30 �š�
      
      if to_char(v_data_to,'DD') = '31' then
        v_to_dd := '30';
      end if;

      if to_char(v_data_from,'DD') = '31' then
        v_from_dd := '30';
      end if;

    elsif  p_method = 0 then
      --�������� (NASD)�������ʼ����Ϊĳ�µ����һ�죬����ڵ��µ� 30 �š�
      --�����ֹ����Ϊĳ�µ����һ�죬������ʼ��������ĳ�µ� 30 �ţ�����ֹ���ڵ����¸��µ� 1 �ţ�������ֹ���ڵ��ڵ��µ� 30 �š�

      if v_data_from = last_day(v_data_from) then
        v_from_dd := '30';
      end if;
      
      if v_data_to = last_day(v_data_to) then
        if v_from_dd < '30' then
          v_data_to := v_data_to + 1;
          v_to_yyyy := to_char(v_data_to,'yyyy');
          v_to_mm := to_char(v_data_to,'mm');
          v_to_dd := to_char(v_data_to,'dd');
        else
          v_to_dd := '30';
        end if;  
      end if;
      
    end if;
    
    
    loop
      i := i + 1;
      if i = 1 then
        v_tmp_yyyy := v_from_yyyy;
        v_tmp_mm := v_from_mm;
        v_tmp_dd := v_from_dd;
      else
        v_tmp_mm := v_tmp_mm + 1;
        if v_tmp_mm = 13 then
          v_tmp_mm := 1;
          v_tmp_yyyy := v_tmp_yyyy + 1;
        end if;
        v_tmp_dd := 0; 
      end if;
      
      if v_tmp_yyyy||v_tmp_mm = v_to_yyyy||v_to_mm then
        --���1��ѭ��
        v_days := v_days + (v_to_dd - v_tmp_dd);
        
        exit;
        
      else
        
        v_days := v_days + (30 - v_tmp_dd); 
      end if;
      
    end loop;
    
    v_days := v_days * v_sign;


  end if;

  return(v_days);
end days_between;
/
