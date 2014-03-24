using System;
using System.Collections;

namespace Chanjet.TP.Core
{
    /// <summary>
    /// 缓存接口
    /// </summary>
    public interface ICache
    {
       
       /// <summary>
        /// 按键从缓存中存取值
       /// </summary>
       /// <param name="key"></param>
       /// <returns></returns>
        object this[string key]
        {
            get;
            set;
        } 
        /// <summary>
        /// 添加一个缓存项
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        void Add(string key, object value);
        /// <summary>
        /// 删除一个缓存项
        /// </summary>
        /// <param name="key"></param>
        void Remove(string key);
        /// <summary>
        /// 判断键是否存在
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        bool Contains(string key);
        /// <summary>
        /// 清空缓存
        /// </summary>
        void Clear();
      
    }
}
