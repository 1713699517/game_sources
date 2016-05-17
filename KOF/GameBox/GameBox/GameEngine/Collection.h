//
//  Collection.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__ContainerCollection__
#define __GameBox__ContainerCollection__

USING_NS_CC;

namespace ptola
{
namespace gui
{

    template<typename _T = CCObject *>
    class CCollection : public CCObject
    {
    public:
        _T at(unsigned int uIndex)
        {
            _T pRet = dynamic_cast<_T>(m_Array.objectAtIndex(uIndex));
            return pRet;
        };

        unsigned int at(_T value)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            return m_Array.indexOfObject(pObject);
        };

        void addObject(_T value)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            if( pObject != NULL )
                m_Array.addObject(pObject);
        };

        void insertObject(_T value, unsigned int uIndex)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            if( pObject != NULL )
                m_Array.insertObject(pObject, uIndex);
        };

        void removeObject(_T value)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            if( pObject != NULL )
                m_Array.removeObject(pObject);
        };

        void removeObjectAtIndex(unsigned int uIndex)
        {
            m_Array.removeObjectAtIndex(uIndex);
        };

        void replaceObjectAtIndex(unsigned int uIndex, _T value)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            if( pObject != NULL )
                m_Array.replaceObjectAtIndex(uIndex, pObject);
        };

        void pushBack(_T value)
        {
            addObject(value);
        };

        void pushFront(_T value)
        {
            insertObject(value, 0U);
        };

        void popBack()
        {
            if( m_Array.count() == 0U )
                return;
            m_Array.removeObjectAtIndex(m_Array.count() - 1);
        };

        void popFront()
        {
            if( m_Array.count() == 0U )
                return;
            m_Array.removeObjectAtIndex(0U);
        };

        _T front()
        {
            return at(0U);
        };

        _T back()
        {
            _T pRet = dynamic_cast<_T>(m_Array.lastObject());
            return pRet;
        };

        bool empty()
        {
            return m_Array.count() == 0U;
        };

        unsigned int count()
        {
            return m_Array.count();
        };

        bool contains( _T value)
        {
            CCObject *pObject = dynamic_cast<CCObject *>(value);
            if( pObject == NULL )
                return false;
            return m_Array.containsObject(pObject);
        };

        void removeAllObjects()
        {
            m_Array.removeAllObjects();
        };

        _T randomObject()
        {
            _T pRet = dynamic_cast<_T>(m_Array.randomObject());
            return pRet;
        };

        void reverseObjects()
        {
            m_Array.reverseObjects();
        };

        void exchangeObject(_T v1, _T v2)
        {
            CCObject *pObject1 = dynamic_cast<CCObject *>(v1);
            CCObject *pObject2 = dynamic_cast<CCObject *>(v2);
            if( pObject1 != NULL && pObject2 != NULL )
                m_Array.exchangeObject(pObject1, pObject2);
        };

        void exchangeObjectAtIndex(unsigned int uIndex1, unsigned int uIndex2)
        {
            m_Array.exchangeObjectAtIndex(uIndex1, uIndex2);
        }
        
    private:
        CCArray m_Array;
    };

}
}

#endif /* defined(__GameBox__ContainerCollection__) */
