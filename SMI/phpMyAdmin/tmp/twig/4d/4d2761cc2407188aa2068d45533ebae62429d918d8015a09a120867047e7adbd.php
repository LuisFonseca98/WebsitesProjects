<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* navigation/item_unhide_dialog.twig */
class __TwigTemplate_c3c8377d667a99bd906a2bc4e70558d3cf9f10eb928b3bce6bcd9f917d542f9b extends \Twig\Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        echo "<form class=\"ajax\" action=\"navigation.php\" method=\"post\">
  <fieldset>
    ";
        // line 3
        echo PhpMyAdmin\Url::getHiddenInputs(($context["database"] ?? null), ($context["table"] ?? null));
        echo "

    ";
        // line 5
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable(($context["types"] ?? null));
        $context['loop'] = [
          'parent' => $context['_parent'],
          'index0' => 0,
          'index'  => 1,
          'first'  => true,
        ];
        if (is_array($context['_seq']) || (is_object($context['_seq']) && $context['_seq'] instanceof \Countable)) {
            $length = count($context['_seq']);
            $context['loop']['revindex0'] = $length - 1;
            $context['loop']['revindex'] = $length;
            $context['loop']['length'] = $length;
            $context['loop']['last'] = 1 === $length;
        }
        foreach ($context['_seq'] as $context["type"] => $context["label"]) {
            // line 6
            echo "      ";
            if (((twig_test_empty(($context["item_type"] ?? null)) || (($context["item_type"] ?? null) == $context["type"])) && twig_test_iterable((($__internal_f607aeef2c31a95a7bf963452dff024ffaeb6aafbe4603f9ca3bec57be8633f4 = ($context["hidden"] ?? null)) && is_array($__internal_f607aeef2c31a95a7bf963452dff024ffaeb6aafbe4603f9ca3bec57be8633f4) || $__internal_f607aeef2c31a95a7bf963452dff024ffaeb6aafbe4603f9ca3bec57be8633f4 instanceof ArrayAccess ? ($__internal_f607aeef2c31a95a7bf963452dff024ffaeb6aafbe4603f9ca3bec57be8633f4[$context["type"]] ?? null) : null)))) {
                // line 7
                echo "        ";
                echo (( !twig_get_attribute($this->env, $this->source, $context["loop"], "first", [], "any", false, false, false, 7)) ? ("<br>") : (""));
                echo "
        <strong>";
                // line 8
                echo twig_escape_filter($this->env, $context["label"], "html", null, true);
                echo "</strong>
        <table class=\"all100\">
          <tbody>
            ";
                // line 11
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable((($__internal_62824350bc4502ee19dbc2e99fc6bdd3bd90e7d8dd6e72f42c35efd048542144 = ($context["hidden"] ?? null)) && is_array($__internal_62824350bc4502ee19dbc2e99fc6bdd3bd90e7d8dd6e72f42c35efd048542144) || $__internal_62824350bc4502ee19dbc2e99fc6bdd3bd90e7d8dd6e72f42c35efd048542144 instanceof ArrayAccess ? ($__internal_62824350bc4502ee19dbc2e99fc6bdd3bd90e7d8dd6e72f42c35efd048542144[$context["type"]] ?? null) : null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 12
                    echo "              <tr>
                <td>";
                    // line 13
                    echo twig_escape_filter($this->env, $context["item"], "html", null, true);
                    echo "</td>
                <td class=\"right\">
                  <a class=\"unhideNavItem ajax\" href=\"navigation.php\" data-post=\"";
                    // line 15
                    echo PhpMyAdmin\Url::getCommon(["unhideNavItem" => true, "itemType" =>                     // line 17
$context["type"], "itemName" =>                     // line 18
$context["item"], "dbName" =>                     // line 19
($context["database"] ?? null)], "");
                    // line 20
                    echo "\">";
                    echo PhpMyAdmin\Util::getIcon("show", _gettext("Unhide"));
                    echo "</a>
                </td>
              </tr>
            ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 24
                echo "          </tbody>
        </table>
      ";
            }
            // line 27
            echo "    ";
            ++$context['loop']['index0'];
            ++$context['loop']['index'];
            $context['loop']['first'] = false;
            if (isset($context['loop']['length'])) {
                --$context['loop']['revindex0'];
                --$context['loop']['revindex'];
                $context['loop']['last'] = 0 === $context['loop']['revindex0'];
            }
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['type'], $context['label'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 28
        echo "  </fieldset>
</form>
";
    }

    public function getTemplateName()
    {
        return "navigation/item_unhide_dialog.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  124 => 28,  110 => 27,  105 => 24,  94 => 20,  92 => 19,  91 => 18,  90 => 17,  89 => 15,  84 => 13,  81 => 12,  77 => 11,  71 => 8,  66 => 7,  63 => 6,  46 => 5,  41 => 3,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "navigation/item_unhide_dialog.twig", "C:\\xampp\\phpMyAdmin\\templates\\navigation\\item_unhide_dialog.twig");
    }
}
