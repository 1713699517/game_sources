class CPageScrollView : public CUserControl
{
public:

    static CPageScrollView *create();

    static CPageScrollView *create(enumLayoutDirection dir, CCSize &_size);


    void addPage(CContainer *pContainer);
    void removePage(CContainer *pContainer);
    void removePageByIndex(int nPageIndex);
    void setContainer(CContainer *pContainer);

    void setPage(int nPage, bool bAnimated);
    int getPage();

    int getPageCount();
};
