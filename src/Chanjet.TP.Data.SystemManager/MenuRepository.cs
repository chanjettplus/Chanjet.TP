using Chanjet.TP.Core;
using Chanjet.TP.Core.Context;
using Chanjet.TP.Data;
using Chanjet.TP.Model;
using Chanjet.TP.SystemManager.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.SystemManager.Data
{
    public class MenuRepository :RepositoryBase<Menu>, IMenuRepository
    {
        private IDatabase _db;
        private ICache _cache;
        private IThreadContext _context;
        private IUnitOfWork _uow;

        public MenuRepository(IDatabase db,  ICache cache, IThreadContext context, IUnitOfWork uow)
            :base(db)
        {
            _db = db;
            _cache = cache;
            _context = context;
            _uow = uow;
            
        }
        public override IEnumerable<Menu> GetAll()
        {
      
            var userName = _context.CurrentUser.Additional.UserName; //取上下文UserName
            return _db.Query<Menu>("select * from eap_menu");
         
        }
    }
}
