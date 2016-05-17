    class CRadioBox : public CCheckBox
    {
    public:
        
        void setChecked(bool bChecked);

        //执行组状态改变
        void performGroupStateChanged();
        
    };
