using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class NullableValue<T>
    {
        public T Value { get; set; }
        public bool HasValue { get; private set; }

        public NullableValue(T val)
        {
            this.Value = val;
            this.HasValue = true;
        }

        public NullableValue()
        {
            this.HasValue = false;
        }
    }
}
