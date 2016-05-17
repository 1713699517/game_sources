//
//  Tab.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "Tab.h"

#include "MemoryAllocator.h"
#include "LuaScriptFunctionInvoker.h"

using namespace ptola::memory;
using namespace ptola::script;
using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CTab);

CTab::CTab()
: m_LayoutDirection(eLD_Relative)
, m_pCurrentContainer(NULL)
, m_pTabPageLayout(NULL)
{
    
}

CTab::~CTab()
{
    
}

bool CTab::init()
{
    return CUserControl::init();
}

bool CTab::init(enumLayoutDirection m_value, const CCSize &_cellSize)
{
    if(!CUserControl::init())
        return onInitialized(false);
    m_LayoutDirection = m_value;
    
    m_pTabPageLayout = NULL;
    if( m_value == eLD_Horizontal)
    {
        m_pTabPageLayout = CHorizontalLayout::create();
    }
    else
    {
        m_pTabPageLayout = CVerticalLayout::create();
    }
    m_pTabPageLayout->setCellSize(_cellSize);

    addChild(m_pTabPageLayout, 10);

    return onInitialized(true);
}



void CTab::addTab(CTabPage *pTabPage, CContainer *pTabContainer)
{    
    m_pTabPageLayout->addChild(pTabPage);

    if (m_pCurrentContainer!=NULL)
    {
        m_pCurrentContainer->removeFromParentAndCleanup(false);
    }
    
    addChild(pTabContainer);
    m_pCurrentContainer = pTabContainer;
    m_pCollectionContainer.addObject(pTabContainer);
    m_pCollectionTabPages.addObject(pTabPage);
    
    m_mapTabPages.insert(make_pair(pTabPage,pTabContainer));
    
}

CTab* CTab::create(enumLayoutDirection _value, const CCSize &_cellSize)
{
    CTab *pTab = new CTab();
    if (pTab && pTab->init(_value, _cellSize))
    {
        pTab->autorelease();
        return pTab;
    }
    else
    {
        CC_SAFE_DELETE(pTab);
        return NULL;
    }
}

void CTab::onTabChange(CTabPage *pTabPage )
{
    map< CTabPage *,CContainer *>::iterator temp = m_mapTabPages.find(pTabPage);
    if( temp != m_mapTabPages.end() )
    {
        for( map<CTabPage *, CContainer *>::iterator it = m_mapTabPages.begin();
            it != m_mapTabPages.end(); it++ )
        {
            it->first->setChecked( (it->first == pTabPage) );
        }
        if( m_pCurrentContainer != NULL )
        {
            m_pCurrentContainer->removeFromParentAndCleanup(false);
        }
        addChild(temp->second);
        m_pCurrentContainer = temp->second;

        //TabPageChanged
        CLuaScriptFunctionInvoker::executeTabPageChangedScript(m_pControlScriptHandler, this);
    }
}

void CTab::removeTabByIndex( unsigned int uIndex )
{
    if( uIndex < m_pCollectionTabPages.count() && uIndex < m_pCollectionContainer.count())
    {
        CTabPage *pPage = m_pCollectionTabPages.at(uIndex);
        if( pPage != NULL )
        {
            removeTab(pPage);
        }
    }
}

void CTab::removeTab( CTabPage *pTabPage )
{
    map< CTabPage *, CContainer *>::iterator temp = m_mapTabPages.find(pTabPage);
    if( temp != m_mapTabPages.end() )
    {
        m_mapTabPages.erase(temp);
        m_pCollectionTabPages.removeObject(pTabPage);
        m_pCollectionContainer.removeObject(m_pCurrentContainer);

        bool reIndex = m_pCurrentContainer == temp->second;
        if( reIndex )
        {   //redefine currentcontainer
            m_pCurrentContainer->removeFromParentAndCleanup(true);
            m_pCurrentContainer = NULL;
        }
        m_pTabPageLayout->removeChild(pTabPage, true);

        if( reIndex )
        {
            setSelectedTabIndex(0U);
        }
    }
}

void CTab::setSelectedTabIndex(unsigned int uIndex)
{
    if( uIndex < m_pCollectionTabPages.count() && uIndex < m_pCollectionContainer.count())
    {
        CTabPage *pPage = m_pCollectionTabPages.at(uIndex);
        if( pPage != NULL )
        {
            onTabChange(pPage);
        }
    }
}

