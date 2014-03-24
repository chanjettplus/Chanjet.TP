using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core.Cache
{
    /// <summary>
    /// ICache的缺省实现
    /// </summary>
    public class DefaultCache : ICache
    {
        private Dictionary<string, object> cacheDic = new Dictionary<string, object>();
        private object lockObject = new object(); //独占锁定对象       

        /// <summary>
        /// 缓存项数
        /// </summary>
        public int Count
        {
            get
            {
                lock (lockObject)
                {
                    return cacheDic.Count;
                }
            }
        }
        /// <summary>
        /// 按键从缓存中存取值
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public object this[string key]
        {
            get
            {
                lock (lockObject)
                {
                    if (cacheDic.ContainsKey(key))
                    {
                        return cacheDic[key];
                    }
                    return null;
                }
            }
            set
            {
                lock (lockObject)
                {
                    if (cacheDic.ContainsKey(key))
                    {
                        cacheDic[key] = value;
                    }
                    else
                    {
                        cacheDic.Add(key, value);
                    }
                }
            }
        }


        /// <summary>
        /// 添加一个缓存项
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public void Add(string key, ICloneable value)
        {
            if (key != null && value != null)
            {
                lock (lockObject)
                {
                    if (!cacheDic.ContainsKey(key))
                    {
                        cacheDic.Add(key, value);
                    }

                }
            }
        }

        /// <summary>
        /// 删除一个缓存项
        /// </summary>
        /// <param name="key"></param>
        public void Remove(string key)
        {
            lock (lockObject)
            {
                if (cacheDic.ContainsKey(key))
                {
                    cacheDic.Remove(key);
                }
            }
        }

        /// <summary>
        /// 判断键是否存在
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Contains(string key)
        {
            lock (lockObject)
            {
                return cacheDic.ContainsKey(key);
            }
        }

        /// <summary>
        /// 清空缓存
        /// </summary>
        public void Clear()
        {
            lock (lockObject)
            {
                cacheDic.Clear();
            }
        }


    }

}

