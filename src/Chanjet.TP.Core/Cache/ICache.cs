using System;
using System.Collections;

namespace Chanjet.TP.Core
{
    /// <summary>
    /// ����ӿ�
    /// </summary>
    public interface ICache
    {
       
       /// <summary>
        /// �����ӻ����д�ȡֵ
       /// </summary>
       /// <param name="key"></param>
       /// <returns></returns>
        object this[string key]
        {
            get;
            set;
        } 
        /// <summary>
        /// ���һ��������
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        void Add(string key, object value);
        /// <summary>
        /// ɾ��һ��������
        /// </summary>
        /// <param name="key"></param>
        void Remove(string key);
        /// <summary>
        /// �жϼ��Ƿ����
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        bool Contains(string key);
        /// <summary>
        /// ��ջ���
        /// </summary>
        void Clear();
      
    }
}
