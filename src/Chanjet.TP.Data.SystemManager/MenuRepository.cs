using Chanjet.TP.Core;
using Chanjet.TP.Core.Context;
using Chanjet.TP.Data;
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

        
        public MenuRepository(IDatabase db, ICache cache, IThreadContext context)
            :base(db)
        {
            _db = db;
            _cache = cache;
            _context = context;

        }
        public override IEnumerable<Menu> GetAll()
        {

            return _db.Query<Menu>("select * from eap_menu");
        }
    }
}
