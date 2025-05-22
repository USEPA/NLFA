//patches JQuery to work with DevExpress

function PatchJQuery()
{
    if (!window.jQuery || !window.jQuery.clean)
        return;

    var original = window.jQuery.clean;
    window.jQuery.clean = function(elems, context, fragment, scripts)
    {
        var execResult = original.call(jQuery, elems, context, fragment, scripts);
        if (scripts && scripts.length)
        {
            for (var i = scripts.length - 1; i >= 0; i--)
            {
                var script = scripts[i];
                if (IsDXScript(script))
                    ArrayRemoveAt(scripts, i);
            }
        }
        return execResult;
    };
}

// Utils
function IsDXScript(script)
{
    return script && script.id && script.id.indexOf("dx") == 0;
}
function ArrayRemoveAt(array, index)
{
    if (index >= 0 && index < array.length)
    {
        for (var i = index; i < array.length - 1; i++)
            array[i] = array[i + 1];
        array.pop();
    }
}

PatchJQuery();